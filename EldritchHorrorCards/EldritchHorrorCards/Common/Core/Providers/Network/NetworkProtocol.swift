 //
//  NetworkProtocol.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
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
