//
//  ConfigProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/13/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
import RealmSwift

typealias ConfigCompletion = (Bool) -> Void

protocol ConfigProviderProtocol {
	var config: Config { get set }
	func load()
	func save(completion: ConfigCompletion?)
}

class ConfigProvider: ConfigProviderProtocol {
	var config: Config = Config()
	
	func load() {
		let realm = try! Realm()
		if let obj = realm.objects(ROConfig.self).first {
			self.config = Config(managedObject: obj)
		}
	}
	
	func save(completion: ConfigCompletion? = nil) {
		background {
			let container = try! Container()
			try! container.write { transaction in
				transaction.add(self.config, update: true)
			}
			main { completion?(true) }
		}
	}
}
