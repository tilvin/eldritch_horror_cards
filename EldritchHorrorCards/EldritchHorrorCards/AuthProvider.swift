//
//  AuthProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol AuthProviderProtocol {
	var token: String { get set }
	var login: String { get set }
	
	func loadToken() -> Bool
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void)
	func logout(error: Swift.Error?)
	func clear()
}

extension AuthProviderProtocol {
	var isAuthorized: Bool {
		guard  !token.isEmpty else { return false }
		return true
	}
}

class AuthProvider: AuthProviderProtocol {
	
	var token: String = ""
	var login: String = ""
	
	func loadToken() -> Bool {
		token = UserDefaults.standard.string(forKey: "token") ?? ""
		login = UserDefaults.standard.string(forKey: "login") ?? ""
		
		return !token.isEmpty && !login.isEmpty
	}
	
	func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void) {
		Log.writeLog(logLevel: .info, message: "Fake token!")
		self.login = login
		self.token = UUID().uuidString
		
		UserDefaults.standard.set(login, forKey: "login")
		UserDefaults.standard.set(token, forKey: "token")
		completion(true)
	}
	
	func logout(error: Swift.Error?) {
		clear()
		Log.writeLog(logLevel: .debug, message: "show auth view controller")
		Router.presentAuth()
	}
	
	func clear() {
		token = ""
		login = ""
		UserDefaults.standard.set(nil, forKey: "login")
		UserDefaults.standard.set(nil, forKey: "token")
	}
}

extension AuthProvider {

	enum Error: Swift.Error {
		case cancelled
		case needAuthorize
	}
}
