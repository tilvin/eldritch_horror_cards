//
// Created by Andrey Torlopov on 8/12/18.
// Copyright (c) 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

enum APIRequest {
	case login(login: String, password: String)
	case games(user_uid: String)
	case gameSets
	
}

extension APIRequest {
	static private let apiURL: URL = URL(string: "https://82.202.236.16/api/mobile_app/v1")!
	static private let userAgent: String = {
		return "EldritchHorrorCards:ios"
	}()

	var request: URLRequest {
		let components = self.components
		let url = APIRequest.apiURL.appendingPathComponent(components.path)
		var request = URLRequest(url: url)

		request.httpMethod = self.method
//		request.setValue(APIRequest.userAgent, forHTTPHeaderField: "User-Agent")
		
		for header in components.headers {
			request.setValue(header.value, forHTTPHeaderField: header.key)
		}

		if components.asJson {
			request.httpBody = try! JSONSerialization.data(withJSONObject: components.parameters, options: .prettyPrinted)
		}
		else {
			request.httpBody = urlEncodedParameters(params: components.parameters).data(using: .utf8)
		}
		
		return request
	}

	private struct Components {
		var path: String!
		var parameters: [String: Any] = [:]
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
		case .games(let user_uid):
			components.path = "/games"
			components.parameters["user_uid"] = user_uid
		case .gameSets:
			components.path = "/game_sets"
			components.asJson = false
			return components
		}
	}

	private var method: String {
		switch self {
		case .login, .games:
			return "POST"
		case .gameSets:
			return "GET"
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
