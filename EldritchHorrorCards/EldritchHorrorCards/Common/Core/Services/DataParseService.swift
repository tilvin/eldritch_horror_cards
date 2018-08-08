//
//  DataParseService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

enum DataParseResult {
	case monsters(monsters: [Monster])
	case users(users: [User])
	case decks(deck: Decks)
	case error(error: String)
}

enum DataType: String {
	case monster, decks, users
}

protocol DataParseServiceProtocol {
	func parse(type: DataType, json: Any) -> DataParseResult
}

class DataParseService: DataParseServiceProtocol {
	private var data: Data?

	func parse(type: DataType, json: Any) -> DataParseResult {
		guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: []),
			  let jsonStr = String(data: jsonData, encoding: .utf8) else {
			return .error(error: "Can't parse data json!")
		}

		data = jsonStr.data(using: .utf8)

		switch type {
		case .users:
			if let model = value([User].self) { return .users(users: model) }
			return .error(error: "Can't parse users!")
		case .monster:
			if let model = value([Monster].self) { return .monsters(monsters: model) }
			return .error(error: "Can't parse monsters!")
		case .decks:
			if let model = value(Decks.self) { return .decks(deck: model) }
			return .error(error: "Can't parse cards!")
		}
	}
}

//MARK: - Fetch extensions

extension DataParseService {
	private func value<T>(_ type: T.Type) -> T? where T: Codable {
		if let data = data as? T { return data }
		
		if let data = data {
			do {
				let json = try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
				if let val = json as? T {
					return val
				}
			}
			catch _ {}
			return try? JSONDecoder().decode(type, from: data)
		}
		return nil
	} 
}

