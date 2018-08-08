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
	private var configProvider: ConfigProviderProtocol!
	var currentUser: User?
	
	func loadToken() -> Bool {
		if configProvider == nil {
			configProvider = DI.providers.resolve(ConfigProviderProtocol.self)
		}
		guard !configProvider.token.isEmpty else {
			return false
		}
		return !configProvider.login.isEmpty && !configProvider.token.isEmpty
	}
	
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void) {
		Log.writeLog(logLevel: .info, message: "Fake token!")
		if let userLogin = currentUser?.login, let userToken = currentUser?.token {
			configProvider.login = userLogin
			configProvider.token = userToken
			configProvider.save { (success) in
				if !success {
					Log.writeLog(logLevel: .error, message: "Can't save login and token!")
				}
			}
			completion(true)
		}
		else {
			print("Login is false")
			completion(false)
		}
	}
	
	func logout(error: String?) {
		clear()
		Log.writeLog(logLevel: .debug, message: "show auth view controller")
		Router.presentAuth()
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
			let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
			else {
				print("can't parse json!")
				return
		}
		Log.writeLog(logLevel: .debug, message: "Json parsed... \(data)")
		if let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) {
			let jsonUsers = DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: .users, json: json)
			switch jsonUsers {
			case .users(let users):
				if users.contains(where: {$0.login ==  loginUser}) {
					currentUser = users.filter {$0.login ==  loginUser}[0]
					if let userImageURL = currentUser?.imageURL {
						loadImage(imageURL: userImageURL)
					}
				}
				completion(true)
			case .error(let error):
				Log.writeLog(logLevel: .error, message: error)
				completion(false)
			default: break
			}
		}
		else {
			Log.writeLog(logLevel: .error, message: "Invalid serialize data")
			completion(false)
		}
	}
}
