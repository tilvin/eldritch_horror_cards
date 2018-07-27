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
    func logout(error: String?)
    func clear()
}

extension AuthProviderProtocol {
    var isAuthorized: Bool {
        guard  !token.isEmpty else { return false }
        return true
    }
}

class AuthProvider: AuthProviderProtocol {
    private var configProvider: ConfigProviderProtocol!
    var token: String = ""
    var login: String = ""
    
    func loadToken() -> Bool {
        
        if configProvider == nil {
            configProvider = DI.providers.resolve(ConfigProviderProtocol.self)
        }
        guard !configProvider.token.isEmpty else {
            return false
        }
        token = configProvider.token
        login = configProvider.login
        return !configProvider.login.isEmpty && !configProvider.token.isEmpty
    }
    
    func authorize(with login: String, password: String, completion: @escaping (Bool) -> Void) {
        Log.writeLog(logLevel: .info, message: "Fake token!")
        self.login = login
        self.token = UUID().uuidString
        configProvider.login = login
        configProvider.token = token
        configProvider.save { (success) in
            if !success {
                Log.writeLog(logLevel: .error, message: "Can't save login and token!")
            }
        }
        completion(true)
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
}
