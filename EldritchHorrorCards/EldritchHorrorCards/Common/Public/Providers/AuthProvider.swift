//
//  AuthProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol AuthProviderProtocol {
	var currentUser: User? { get set }

	func loadToken() -> Bool
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void)
	func logout(error: String?)
	func clear()
	func load(with login: String, completion: @escaping (Bool) -> Void)
}

class AuthProvider: AuthProviderProtocol {
	private var configProvider = DI.providers.resolve(ConfigProviderProtocol.self)!
	var currentUser: User?

	func loadToken() -> Bool {
		guard !configProvider.token.isEmpty else { return false }
		return !configProvider.login.isEmpty && !configProvider.token.isEmpty
	}

	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void) {
		guard let userLogin = currentUser?.login, let userToken = currentUser?.token else {
			completion(false)
			return
		}
		
		configProvider.login = userLogin
		configProvider.token = userToken
		configProvider.save { (success) in
			if !success { print("Can't save login and token!") }
		}
		completion(true)
	}

	func logout(error: String?) {
		clear()
	}

	func clear() {
		configProvider.token = ""
		configProvider.login = ""
		configProvider.save(completion: nil)
	}

	private func loadImage(imageURL:String)  {
		DispatchQueue.global(qos: .utility).async {
			guard let imageUrl = URL(string: imageURL) else { return }
			guard let imageData = NSData(contentsOf: imageUrl) else { return }
			UserDefaults.standard.set(imageData, forKey: "avatar")
		}
	}

	func load(with loginUser: String, completion: @escaping (Bool) -> Void) {
		guard let path = Bundle.main.path(forResource: "users", ofType: "json"),
			  let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else { return }

		guard let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) else {
			completion(false)
			return
		}

		let jsonUsers = DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: .users, json: json)
		
		switch jsonUsers {
		case .users(let users):
			currentUser = users.filter { $0.login == loginUser }.first
			if let userImageURL = currentUser?.imageURL {
				loadImage(imageURL: userImageURL)
			}
			completion(true)
		case .error(let error):
			Log.writeLog(logLevel: .error, message: error)
			completion(false)
		default: break
		}
	}
}
