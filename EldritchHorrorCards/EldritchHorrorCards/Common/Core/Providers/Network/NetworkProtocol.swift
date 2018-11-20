 //
//  NetworkProtocol.swift
//  Ebs
//
//  Created by Vitalii Poponov on 11.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

enum NetworkConnectionStatus {
	case unavailable
	case wifi
	case wwan
}

protocol NetworkProtocol {
	/// Returns NetworkConnectionStatus over NetworkReachabilityManager interface
	var connectionStatus: NetworkConnectionStatus { get }
	
	var settings: NetworkClientSettings { get }
	
	/// Perform network request with Alamofire
	///
	/// - Parameters:
	///   - route: route to perform
	///   - completion: completion block when response returned
	func load(route: NetworkRouteProtocol, completion: ((NetworkResponse) -> Void)?)
	
	func load(route: NetworkRouteProtocol, redirection: ((URLRequest?, HTTPURLResponse?) -> Void)?, completion: ((NetworkResponse) -> Void)?)
	
	func urlRequest(route: NetworkRouteProtocol) -> URLRequest
	
	func upload(route: NetworkRouteProtocol, items: [MultipartDataItem], redirection: ((URLRequest?, HTTPURLResponse?) -> Void)?, needPerformRedirection: Bool, completion: ((NetworkResponse) -> Void)?)
}
