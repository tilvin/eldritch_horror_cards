//
//  Network.swift
//  Ebs
//
//  Created by Vitalii Poponov on 11.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Alamofire

class Network: NetworkProtocol {
	//MARK: - Variables
	
	lazy var reachability: NetworkReachabilityManager? = {
		return NetworkReachabilityManager(host: self.settings.reachabilityHost)
	}()
	let settings: NetworkClientSettings
	let sessionManager: SessionManager
	
	//MARK: - Inits
	
	init(settings: NetworkClientSettings, sessionManager: SessionManager = SessionManager.default) {
		self.sessionManager = sessionManager
		self.settings = settings
	}
	
	//MARK: - Public
	
	public var connectionStatus: NetworkConnectionStatus {
		guard let reachability = self.reachability else { return .unavailable }
		switch reachability.networkReachabilityStatus {
		case .notReachable, .unknown:
			return .unavailable
		case let .reachable(connectionType):
			switch connectionType {
			case .ethernetOrWiFi:
				return .wifi
			case .wwan:
				return .wwan
			}
		}
	}
	
	public func urlRequest(route: NetworkRouteProtocol) -> URLRequest {
		return route.makeURLRequest(settings: settings)
	}
	
	func load(route: NetworkRouteProtocol, completion: ((NetworkResponse) -> Void)?) {
		self.load(route: route, redirection: nil, completion: completion)
	}
	
	public func load(route: NetworkRouteProtocol, redirection: ((URLRequest?, HTTPURLResponse?) -> Void)? = nil, completion: ((NetworkResponse) -> Void)? ) {
		let urlRequest = self.urlRequest(route: route)
		self.sessionManager.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
			redirection?(request, response)
			return request
		}
		
		print("====================OUTGOING REQUEST: \(urlRequest)====================")
		self.sessionManager.request(urlRequest).responseJSON(completionHandler: { (result) in
			if let action = completion {
				print("---------------------INCOMING RESPONSE: \(result)---------------------")
				let response = NetworkResponse(response: result)
				action(response)
			}
		})
	}
	
	public func upload(route: NetworkRouteProtocol, items: [MultipartDataItem], redirection: ((URLRequest?, HTTPURLResponse?) -> Void)? = nil, needPerformRedirection: Bool = true, completion: ((NetworkResponse) -> Void)? ) {
		let urlRequest = self.urlRequest(route: route)
		self.sessionManager.delegate.taskWillPerformHTTPRedirection = { session, task, response, request in
			redirection?(request, response)
			return needPerformRedirection ? request : nil
		}
		
		let multipartFormData: (MultipartFormData) -> Void = {
			(formData) in
			items.forEach({ (item) in
				if let mimeType = item.mimeType, let fileName = item.fileName {
					formData.append(item.data, withName: item.name, fileName: fileName, mimeType: mimeType)
				}
				else {
					formData.append(item.data, withName: item.name)
				}
			})
		}
		
		sessionManager.upload(multipartFormData: multipartFormData, usingThreshold: UInt64(), to: urlRequest.url!, method: HTTPMethod(rawValue: urlRequest.httpMethod ?? "") ?? .post, headers: urlRequest.allHTTPHeaderFields ?? [:]) { (result) in
			switch result {
			case .success(let request, _, _):
				request.responseJSON(completionHandler: { (result) in
					print(result)
				})
				request.response(completionHandler: { (result) in
					if let action = completion {
						let response = NetworkResponse(defaultResponse: result)
						action(response)
					}
				})
			case .failure:
				print("Error: self.sessionManager.upload")
			}
		}
	}
}
