//
//  NetworkSettingsProvider.swift
//  Ebs
//
//  Created by Vitalii Poponov on 11.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

enum ContentTypes: String {
	case urlEncoded = "application/x-www-form-urlencoded"
	case json = "application/json;charset=UTF-8"
	case formData = "multipart/form-data"
	case accept = "application/vnd.ebs.v1.mobile.ios+json"
	case userAgent = "Mozilla/5.0 (iPad; CPU OS 12_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/16A5354b"
}

struct NetworkClientSettings {
	enum HeaderKeys: String {
		case acceptEncoding = "Accept-Encoding"
		case contentType = "Content-Type"
		case authorization = "Authorization"
		case host = "Host"
		case accept = "Accept"
		case userAgent = "User-Agent"
	}
	
	let baseURL: String
	let defaultHeaders: [HeaderKeys: String]
	let reachabilityHost: String
}

protocol NetworkSettingsProviderProtocol {
	func settings(for baseUrl: String) -> NetworkClientSettings
}

class NetworkSettingsProvider: NetworkSettingsProviderProtocol {
	private struct Constants {
		static let networkReachabilityHost = "https://test.cubux.net"
	}
	
	func settings(for baseUrl: String) -> NetworkClientSettings {
		return NetworkClientSettings(
			baseURL: baseUrl,
			defaultHeaders: self.defaultHeaders,
			reachabilityHost: Constants.networkReachabilityHost
		)
	}
	
	var defaultHeaders: [NetworkClientSettings.HeaderKeys: String] = [:]
}
