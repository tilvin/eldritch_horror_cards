//
//  ConfigProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/13/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

typealias ConfigCompletion = (Bool) -> Void

protocol ConfigProviderProtocol {
    var token: String { get set }
    var login: String { get set }
    func load()
    func save(completion: ConfigCompletion?)
}

class ConfigProvider: ConfigProviderProtocol {
    var token: String = ""
    var login: String = ""
    
    func load() {
        token = UserDefaults.standard.string(forKey: "token") ?? ""
        login = UserDefaults.standard.string(forKey: "login") ?? ""
    }
    
    func save(completion: ConfigCompletion? = nil) {
        UserDefaults.standard.set(login, forKey: "login")
        UserDefaults.standard.set(token, forKey: "token")
        completion?(true) 
    }
}

