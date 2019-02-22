//
//  PersistentService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 22/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation

enum PersistentServiceType: String {
	case game = "GAME_KEY"
	case user = "USER_KEY"
	case monster = "MONSTER_KEY"
}

enum PersistentServiceResult {
	case game(Game)
	case user(User)
	case mosters([Monster])
	case failure(String?)
}

protocol PersistentServiceProtocol {
//	func save(objects: [Any], for type: PersistentServiceType)
	func get(type: PersistentServiceType) -> PersistentServiceResult
}

final class PersistentService: PersistentServiceProtocol {
	
	private var userDefaultsDataStore: UserDefaultsDataStoreProtocol!
	
	init(userDefaultsDataStore: UserDefaultsDataStoreProtocol = UserDefaultsDataStore()) {
		self.userDefaultsDataStore = userDefaultsDataStore
	}
	
//	func save(objects: Any, for type: PersistentServiceType) {
//		userDefaultsDataStore.set(key: type.rawValue, value: objects)
//	}
	
	func get(type: PersistentServiceType) -> PersistentServiceResult {
		switch type {
		case .game:
			return .game(Game())
		default:
			return .failure("Test error!")
		}
	}
}
