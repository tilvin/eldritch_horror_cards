//
//  ConfigProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/13/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

typealias ConfigCompletion = (Bool) -> Void

protocol ConfigProtocol {
    var token: String { get set }
    var login: String { get set }
}

struct Config: ConfigProtocol {
    var token: String = ""
    var login: String = ""
}

protocol ConfigProviderProtocol {
    var config: Config { get set }
    func load()
    func save(completion: ConfigCompletion?)
}

class ConfigProvider: ConfigProviderProtocol {
    var config: Config = Config()
    
    func load() {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let login = UserDefaults.standard.string(forKey: "login") ?? ""
        self.config = Config(token: token, login: login)
    }
    
    func save(completion: ConfigCompletion? = nil) {
        UserDefaults.standard.set(self.config, forKey: "config")
        completion?(true) 
    }
}

