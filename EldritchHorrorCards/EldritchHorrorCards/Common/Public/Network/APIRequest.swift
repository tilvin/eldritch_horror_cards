//
// Created by Andrey Torlopov on 8/12/18.
// Copyright (c) 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

private extension URL {
	
	func appendingQueryParameters(_ parameters: [String: String]) -> URL {
		var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true)!
		var items = urlComponents.queryItems ?? []
		items += parameters.map({ URLQueryItem(name: $0, value: $1) })
		urlComponents.queryItems = items
		return urlComponents.url!
	}
}

enum APIRequest {
	case login(login: String, password: String)
	case games
	case gameSets
	case selectGameSets(gameId: Int, addons: [String], maps: [String])
	case ancients(gameId: Int)
	case selectAncient(gameId: Int, ancient: Int)
	case cards(gameId: Int)
	case expedition(gameId: Int, type: String)
	case generalContact(gameId: Int)
	case otherWorldContact(gameId: Int)
	case research(gameId: Int, type: String)
	case special(gameId: Int, type: String)
	case location(gameId: Int, type: String)
	case restoreSession(gameId: Int)
}

extension APIRequest {
	static private let apiURL: URL = URL(string: "http://82.202.236.16/api/mobile_app")!
	static private let userAgent: String = {
		return "EldritchHorrorCards:ios"
	}()
	
	var request: URLRequest {
		let components = self.components
		let url = APIRequest.apiURL.appendingPathComponent(components.path).appendingQueryParameters(components.urlParameters)
		
		var request = URLRequest(url: url)
		
		request.httpMethod = self.method
		
		components.headers.forEach { (key: String, value: String) in
			request.setValue(value, forHTTPHeaderField: key)
		}
		
		if components.asJson {
			request.httpBody = try! JSONSerialization.data(withJSONObject: components.parameters, options: [])
		}
		else {
			request.httpBody = urlEncodedParameters(params: components.parameters).data(using: .utf8)
		}
		
		return request
	}
	
	private struct Components {
		var path: String!
		var parameters: [String: Any] = [:]
		var urlParameters: [String: String] = [:]
		var headers: [String: String] = ["Content-Type": "application/json; charset=utf-8"]
		var emptyBody: Bool = false
		var asJson: Bool = true
	}
	
	private var components: Components {
		var components = Components()
		
		switch self {
		case .login(let login, let password):
			components.path = "\(apiVersionPath)/login"
			components.parameters["login"] = login
			components.parameters["password"] = password
			return components
		case .games:
			components.path = "\(apiVersionPath)/games"
			return components
		case .gameSets:
			components.path = "\(apiVersionPath)/game_sets"
			components.asJson = false
			return components
		case .selectGameSets(let gameId, let addons, let maps):
			components.path = "\(apiVersionPath)/games/\(gameId)"
			components.parameters = ["game": ["game_set_identity": addons, "with_map": maps]]
			return components
		case .ancients(let gameId):
			components.path = "\(apiVersionPath)/ancients"
			components.urlParameters["game_id"] = "\(gameId)"
			components.asJson = false
			return components
		case let .selectAncient(gameId, ancient):
			components.path = "\(apiVersionPath)/games/\(gameId)"
			components.parameters = ["game": ["ancient_id": ancient]]
			return components
		case let .cards(gameId):
			components.path = "\(apiVersionPath)/cards"
			components.urlParameters["game_id"] = "\(gameId)"
			components.asJson = false
			components.headers = [:]
			return components
		case let .expedition(gameId, type):
			components.path = "\(apiVersionPath)/expedition_contacts"
			components.urlParameters["game_id"] = "\(gameId)"
			components.urlParameters["contact_type"] = "\(type)"
			components.asJson = false
			return components
		case let .generalContact(gameId):
			components.path = "\(apiVersionPath)/general_contacts"
			components.urlParameters["game_id"] = "\(gameId)"
			components.asJson = false
			return components
		case let .otherWorldContact(gameId):
			components.path = "\(apiVersionPath)/other_world_contacts"
			components.urlParameters["game_id"] = "\(gameId)"
			components.asJson = false
			return components
		case let .research(gameId, type):
			components.path = "\(apiVersionPath)/research_contacts"
			components.urlParameters["game_id"] = "\(gameId)"
			components.urlParameters["contact_type"] = "\(type)"
			components.asJson = false
			return components
		case let .special(gameId, type):
			components.path = "\(apiVersionPath)/special_contacts"
			components.urlParameters["game_id"] = "\(gameId)"
			components.urlParameters["contact_type"] = "\(type)"
			components.asJson = false
			return components
		case let .location(gameId, type):
			components.path = "\(apiVersionPath)/location_contacts"
			components.urlParameters["game_id"] = "\(gameId)"
			components.urlParameters["contact_type"] = "\(type)"
			components.asJson = false
			return components
		case let .restoreSession(gameId):
			components.path = "\(apiVersionPath)/games/restore"
			components.urlParameters["game_id"] = "\(gameId)"
			components.asJson = false
			components.headers = [:]
			return components
		}
	}
	
	private var method: String {
		switch self {
		case .login, .games:
			return "POST"
		case .gameSets, .ancients, .cards, .expedition, .generalContact, .otherWorldContact, .research, .special, .location, .restoreSession:
			return "GET"
		case .selectGameSets, .selectAncient:
			return "PUT"
		}
	}
	
	private var apiVersionPath: String {
		switch self {
		case .gameSets:
			return "/v2"
		default:
			return "/v1"
		}
	}
	
	private func urlEncodedParameters(params: [String: Any]?) -> String {
		var result = ""
		guard let keys = params?.keys else { return result }
		
		var stringParameters: [String] = []
		for key in keys {
			let value = params![key] ?? ""
			var stringValue: String = ""
			if value is String {
				if let val = value as? String {
					stringValue = escapeValue(string: val)
				}
			}
			else {
				stringValue = escapeValue(string: "\(value)")
			}
			stringParameters.append("\(key)=\(stringValue)")
		}
		result = stringParameters.joined(separator: "&")
		return result
	}
	
	private func escapeValue(string: Any) -> String {
		var result = ""
		if let string = string as? String {
			result = string
		}
		else {
			result = String(describing: string)
		}
		return result.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
}

extension APIRequest {
	
	static func getRequest(cardType: CardType, gameId: Int) -> URLRequest {
		switch cardType {
		case .general:
			return APIRequest.generalContact(gameId: gameId).request
		case .expeditionAntarctica, .expeditionAmazonia, .expeditionHimalayas, .expeditionTunguska, .expeditionAfrica, .expeditionPyramid, .expeditionBuenosAires, .expeditionIstanbul, .expeditionTokyo, .expeditionRoma, .expeditionArkham, .expeditionSydney:
			return APIRequest.expedition(gameId: gameId, type: cardType.rawValue).request
		case .otherWorldContact:
			return APIRequest.otherWorldContact(gameId: gameId).request
		case .yigResearchContact, .ithaquaResearchContact, .elderThingsResearchContact, .yogSothothResearchContact, .nephrenkaResearchContact, .azathothResearchContact, .cthulhuResearchContact, .abhothResearchContact, .shubNiggurathResearchContact, .hasturResearchContact:
			return APIRequest.research(gameId: gameId, type: cardType.rawValue).request
		case .knyanUnearthedSpecialContact, .exploringHyperboreaSpecialContact, .darkGodSpecialContact, .mysteriousDisappearancesSpecialContact, .keyAndGateSpecialContact, .voidBetweenWorldsSpecialContact, .darkPharaohSpecialContact, .blackWindSpecialContact, .rlyehRisenSpecialContact, .deepCavernsSpecialContact, .spawnOfAbhothSpecialContact, .citiesOnLakeSpecialContact, .unspeakableOneSpecialContact, .kingInYellowSpecialContact:
			return APIRequest.special(gameId: gameId, type: cardType.rawValue).request
		case .americaContact, .europeContact, .mountainsContact, .miskatonicExpeditionContact, .asiaAustraliaContact, .egyptContact, .africaeContact:
			return APIRequest.location(gameId: gameId, type: cardType.rawValue).request
		case .unknown:
			fatalError()
		}
	}
}
