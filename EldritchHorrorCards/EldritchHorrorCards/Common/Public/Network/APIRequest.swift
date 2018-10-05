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
	case selectGameSets(gameId: Int, addons: [String])
	case ancients(gameId: Int)
	case selectAncient(gameId: Int, ancient: Int)
}

extension APIRequest {
	static private let apiURL: URL = URL(string: "http://82.202.236.16/api/mobile_app/v1")!
	static private let userAgent: String = {
		return "EldritchHorrorCards:ios"
	}()
	
	var request: URLRequest {
		let components = self.components
		let url = APIRequest.apiURL.appendingPathComponent(components.path).appendingQueryParameters(components.urlParameters)
		
		var request = URLRequest(url: url)
		
		request.httpMethod = self.method
		
		for header in components.headers {
			request.setValue(header.value, forHTTPHeaderField: header.key)
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
		var headers: [String: String] = [:]
		var emptyBody: Bool = false
		var asJson: Bool = true
	}
	
	private var components: Components {
		var components = Components()
		
		switch self {
		case .login(let login, let password):
			components.path = "/login"
			components.parameters["login"] = login
			components.parameters["password"] = password
			return components
		case .games:
			components.path = "/games"
			return components
		case .gameSets:
			components.path = "/game_sets"
			components.asJson = false
			return components
		case .selectGameSets(let gameId, let addons):
			components.path = "/games/\(gameId)"
			components.parameters = ["game": ["game_set_identity": addons]]
			components.headers["Content-Type"] = "application/json; charset=utf-8"
			return components
		case .ancients(let gameId):
			components.path = "/ancients"
			components.urlParameters["game_id"] = "\(gameId)"
			components.asJson = false
			return components
		case .selectAncient(let gameId, let ancient):
			components.path = "/games/\(gameId)"
			components.parameters = ["game": ["ancient_id": ancient]]
			components.headers["Content-Type"] = "application/json; charset=utf-8"
			return components
		}
	}
	
	private var method: String {
		switch self {
		case .login, .games:
			return "POST"
		case .gameSets, .ancients:
			return "GET"
		case .selectGameSets, .selectAncient:
			return "PUT"
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
