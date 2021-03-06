//
//  DataParseService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol DataParseServiceProtocol {
	func parse<T: Codable>(type: T.Type, json: Any, completion: @escaping (T?) -> Void)
	func parse<T: Codable>(type: T.Type, data: Data, completion: @escaping (T?) -> Void)
}

final class DataParseService: DataParseServiceProtocol {
	
	func parse<T: Codable>(type: T.Type, json: Any, completion: @escaping (T?) -> Void) {
		guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
			let jsonStr = String(data: jsonData, encoding: .utf8) else {
				print("Can't parse data json!")
				completion(nil)
				return
		}
		
		let data = jsonStr.data(using: .utf8)
		
		if let data = data {
			parse(type: type, data: data, completion: completion)
		}
		else {
			print("Can't parse \(type)!")
			completion(nil)
		}
	}
	
	func parse<T: Codable>(type: T.Type, data: Data, completion: @escaping (T?) -> Void) {
		if let data = data as? T {
			completion(data)
			return
		}
		
//		if let jsonString = String(data: data, encoding: .utf8),
//			let data = jsonString.data(using: .utf8) {
//			completion(try? JSONDecoder().decode(type, from: data))
//			return
//		}
		
		do {
			let json = try JSONSerialization.jsonObject(with: data, options: [])
			if let val = json as? T {
				completion(val)
			}
		}
		catch _ {}
		completion(try? JSONDecoder().decode(type, from: data))
	}
}

