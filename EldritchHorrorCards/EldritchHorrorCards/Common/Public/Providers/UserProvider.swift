//
//  UserProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 02.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
protocol UserProviderProtocol {
	var users: [User] { get set }
	var user: User? { get set }
	func load(completion: @escaping (Bool) -> Void)
	func recognize()
	
}

class UserProvider: UserProviderProtocol {
	
	var users: [User] = []
	var user: User?
	func load(completion: @escaping (Bool) -> Void) {
		guard let path = Bundle.main.path(forResource: "users", ofType: "json"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
				print("can't parse json!")
				return
		}
		
		Log.writeLog(logLevel: .debug, message: "Json parsed... \(data)")
		
		if let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) {
			let jsonUsers = DataParseService().parse(type: .users, json: json)
			switch jsonUsers {
			case .users(let users):
				self.users = users
				completion(true)
			case .error(let error):
				Log.writeLog(logLevel: .error, message: error)
				completion(false)
			default: break
			}
		}
		else {
			Log.writeLog(logLevel: .error, message: "Invalid serialize data \(data)")
			completion(false)
		}
	}
	func recognize() {
		while users.count > 0 {
			if users[users.count - 1].login == UserDefaults.standard.string(forKey: "login") {
				return user =  users[users.count - 1]
			} else {
				users.remove(at: users.count - 1)
			}
		}
	}
}
