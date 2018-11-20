//
//  NetworkRoute.swift
//  Ebs
//
//  Created by Vitalii Poponov on 11.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRouteProtocol {
	func set(header: String, for key: NetworkClientSettings.HeaderKeys)
	func makeURLRequest(settings: NetworkClientSettings) -> URLRequest
	var params: [AnyHashable: Any]? {get}
}

final class NetworkRoute {
	
	//MARK: - Variables
	
	typealias HeaderKeys = NetworkClientSettings.HeaderKeys
	
	var path: String
	var params: [AnyHashable: Any]?
	var urlParamsAsQuery: Bool = false
	var method: HTTPMethod
	var asJson: Bool = false
	internal var headers: [String: String?] = [:]
	public var asFormEncoded: Bool = false
	var timeout: TimeInterval
	var requestBody: Data?
	
	public func set(header: String, for key: HeaderKeys) {
		self.headers[key.rawValue] = header
	}
	
	//MARK: - Private
	
	private func set(headerAndKeys: [HeaderKeys: String]) {
		for (key, value) in headerAndKeys {
			self.set(header: value, for: key)
		}
	}
	
	private var urlEncodedParameters: String {
		var res = ""
		if let keys = params?.keys {
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
			res = stringParameters.joined(separator: "&")
		}
		return res
	}
	
	private func escapeValue(string: Any) -> String {
		var res = ""
		if let string = string as? String {
			res = string
		}
		else {
			res = String(describing: string)
		}
		return res.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	}
	
	private var httpBody: Data? {
		var data: Data?
		if let requestBody = requestBody {
			data = requestBody
		}
		else if asFormEncoded {
			data = urlEncodedParameters.data(using: .utf8)
		}
		else if method != .get, let params = self.params {
			if asJson {
				data = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
			}
			else {
				data = urlEncodedParameters.data(using: .utf8)
			}
		}
		return data
	}
	
	//MARK: - Inits
	
	public convenience init(path: NetworkRoutePath, params: [AnyHashable: Any] = [:], asJson: Bool = false ) {
		self.init(method: .get, path: path.path, params: params, asJson: asJson)
	}
	
	public convenience init(path: NetworkRoutePath, method: HTTPMethod, params: [AnyHashable: Any] = [:], urlParamsAsQuery: Bool = false) {
		self.init(method: method, path: path.path, params: params, asJson: false, urlParamsAsQuery: urlParamsAsQuery)
	}
	
	public convenience init(path: NetworkRoutePath, method: HTTPMethod, params: [AnyHashable: Any] = [:], requestBody: Data?) {
		self.init(method: method, path: path.path, params: params, asJson: false, urlParamsAsQuery: true, requestBody: requestBody)
	}
	public convenience init(path: String, method: HTTPMethod, params: [AnyHashable: Any] = [:], asFormEncoded: Bool) {
		self.init(method: method, path: path, params: params, asJson: false)
		self.asFormEncoded = asFormEncoded
	}
	
	//Not recommened to use
	internal init(timeout: TimeInterval = 30, method: HTTPMethod, path: String, params: [AnyHashable: Any]?, asJson: Bool, urlParamsAsQuery: Bool = false, requestBody: Data? = nil) {
		self.timeout = timeout
		self.method = method
		self.path = path
		self.params = params
		self.asJson = asJson
		self.urlParamsAsQuery = urlParamsAsQuery
		self.requestBody = requestBody
	}
	
	internal convenience init(path: String, params: [AnyHashable: Any] = [:], asJson: Bool = false ) {
		self.init(method: .get, path: path, params: params, asJson: asJson)
	}
	
	internal convenience init(method: HTTPMethod, path: String, params: [AnyHashable: Any] = [:]) {
		self.init(method: method, path: path, params: params, asJson: false)
	}
}

extension NetworkRoute: NetworkRouteProtocol {
	
	public func makeURLRequest(settings: NetworkClientSettings) -> URLRequest {
		guard let url = makeURL(url: settings.baseURL) else {
			fatalError()
		}
		var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
		request.httpMethod = method.rawValue
		for (key, value) in settings.defaultHeaders {
			request.setValue(value, forHTTPHeaderField: key.rawValue)
		}
		for (key, value) in headers {
			request.setValue(value, forHTTPHeaderField: key)
		}
		
		//as json
		if asJson {
			request.setValue("application/json", forHTTPHeaderField: "Content-type")
		}
		else if asFormEncoded {
			request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
		}
		request.httpBody = httpBody
		return request
	}
	
	private func makeURL(url: String) -> URL? {
		var slash = ""
		if url.last != "/" && self.path.first != "/" {
			slash = "/"
		}
		guard var url = URL(string: url + slash + self.path) else {
			return nil
		}
		if( method == .get || method == .patch) {
			if( urlEncodedParameters.count > 0 ) {
				let prefix: String = url.query != nil ? "&" : "?"
				let string = url.absoluteString + prefix + urlEncodedParameters
				url = URL(string: string)!
			}
		}
		return url
	}
}

extension NetworkRoute {
	
	func setBearer(token: String) {
		self.set(header: "Bearer \(token)", for: .authorization)
	}
}
