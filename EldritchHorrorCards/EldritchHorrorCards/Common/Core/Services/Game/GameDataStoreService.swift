//
//  GameDataStoreService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 23/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol GameDataStoreServiceProtocol {
	func save(_ game: Game)
	func loadGame() -> Game?
	func removeGame()
}

final class GameDataStoreService: GameDataStoreServiceProtocol {
	
	struct Constants {
		static let gameKey = "GAME_KEY"
	}
	
	private let userdefaults = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	
	//MARK: - Public
	
	func save(_ game: Game) {
		userdefaults.set(key: Constants.gameKey, value: try? PropertyListEncoder().encode(game))
	}
	
	func loadGame() -> Game? {
		guard let data = userdefaults.get(key: Constants.gameKey, type: Data.self),
		var game = try? PropertyListDecoder().decode(Game.self, from: data) else {
			return nil
		}
		game.isNewGame = false
		return game
	}
	
	func removeGame() {
		userdefaults.set(key: Constants.gameKey, value: nil)
	}
}
