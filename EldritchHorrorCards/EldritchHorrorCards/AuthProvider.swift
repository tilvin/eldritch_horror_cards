//
//  AuthProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol AuthProviderProtocol {
	var token: String? { get set }
	var login: String? { get set }
	
	func loadToken() -> Bool
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void)
	func logout(error: Swift.Error?)
	func clear()
}

extension AuthProviderProtocol {
	var isAuthorized: Bool {
		guard let token = self.token,
			!token.isEmpty else { return false }
		return true
	}
}

class AuthProvider: AuthProviderProtocol {
	private var configService: ConfigProviderProtocol!
	
	var token: String?
	var login: String?
	
	func loadToken() -> Bool {
		if configService == nil {
			configService = DI.providers.resolve(ConfigProviderProtocol.self)
		}
		guard !configService.config.token.isEmpty else {
			return false
		}
		token = configService.config.token
		login = configService.config.login
		return !configService.config.login.isEmpty && !configService.config.token.isEmpty
	}
	
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void) {
		Log.writeLog(logLevel: .info, message: "Fake token!")
		self.login = login
		self.token = UUID().uuidString
		configService.config.login = login
		configService.config.token = token ?? ""
		configService.save { (success) in
			if !success {
				Log.writeLog(logLevel: .error, message: "Can't save login and token!")
			}
		}
		completion(true)
	}
	
	func logout(error: Swift.Error?) {
		clear()
		Log.writeLog(logLevel: .debug, message: "show auth view controller")
		Router.presentAuth()
	}
	
	func clear() {
		self.token = nil
		configService.config.token = ""
		configService.config.login = ""
		configService.save(completion: nil)
	}
}

extension AuthProvider {

	enum Error: Swift.Error {
		case cancelled
		case needAuthorize
	}
}
