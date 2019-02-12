//
//  NetworkResponse.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import Foundation
import Alamofire

class NetworkResponse {
	
	var response: HTTPURLResponse?
	var error: Error?
	internal var data: Data?
	
	convenience init(response: DataResponse<Any>) {
		self.init()
		self.data = response.data
		self.response = response.response
		self.error = response.error
	}
	
	convenience init(defaultResponse: DefaultDataResponse) {
		self.init()
		self.data = defaultResponse.data
		self.response = defaultResponse.response
		self.error = defaultResponse.error
	}
	
	func value<T>(_ type: T.Type) -> T? where T: Codable {
		if let data = data as? T {
			return data
		}
		if let data = data {
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
				if let val = json as? T {
					return val
				}
			}
			catch _ {}
			let decoder = JSONDecoder()
			return try? decoder.decode(type, from: data)
		}
		return nil
	}
}
