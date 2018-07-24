//
//  ParseService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

enum DataParseResult {
	case mosters(monsters: [Monster])
	case error(error: String)
}

enum DataType: String {
	case moster
}

protocol DataParseServiceProtocol {
	func parse(type: DataType, json: Any) -> DataParseResult
}

class DataParseService: DataParseServiceProtocol {
	
	private var data: Data?
	
	func parse(type: DataType, json: Any) -> DataParseResult {
		guard let jsonDict = json as? [String: Any] else {
			return .error(error: "Can't parse json!")
		}
		
		guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: []),
			let jsonStr = String(data: jsonData, encoding: .utf8) else {
				return .error(error: "Can't parse data json!")
		}
		
		data = jsonStr.data(using: .utf8)
		if let model = value([Monster].self) {
			switch type {
			case .moster:
				return .mosters(monsters: model)
			}
		}
		else {
			return .error(error: "Can't parse \(type) data!")
		}
	}
}

//MARK: - Fetch extensions

extension DataParseService {
	
	private func value<T>(_ type: T.Type) -> T? where T: Codable {
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
