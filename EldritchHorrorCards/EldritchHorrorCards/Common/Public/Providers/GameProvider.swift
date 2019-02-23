//
//  GamesProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 25/09/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol GameDataProviderProtocol {
	var game: Game { get set }
	func loadGame(completion: @escaping (GameDataProviderResults) -> Void)
	func setSelectedAncient(ancient: Monster)
	func removeGame()
}

enum GameDataProviderResults {
	case success
	case failure(error: NetworkErrorModel)
}

final class GameDataProvider: GameDataProviderProtocol {
	
	private struct Constants {
		static let idKey = "game_id_key"
		static let tokenKey = "game_token"
		static let expeditionKey = "expedition_Location"
		static let expireDateKey = "game_date"
		static let gameStoreKey = "game_store_key"
		static let gameObjectKey = "game_object_key"
	}
	
	//MARK: - Public variables
	
	var game = Game()
	
	//MARK: - Private variables
	
	private var gameDataStoreService: GameDataStoreServiceProtocol
	private var gameNetworkService: GameNetworkServiceProtocol
	
	//MARK: - Public
	
	init(gameDataStoreService: GameDataStoreServiceProtocol = GameDataStoreService(),
		 gameNetworkService: GameNetworkServiceProtocol = GameNetworkService()) {
		self.gameDataStoreService = gameDataStoreService
		self.gameNetworkService = gameNetworkService
		self.game = self.gameDataStoreService.loadGame() ?? Game()
	}
	
	public func loadGame(completion: @escaping (GameDataProviderResults) -> Void) {
		guard game.isValid else {
			gameNetworkService.startNewGame(completion: { [unowned self] (result) in
				switch result {
				case .failure(let error):
					completion(.failure(error: error))
				case .success(let game):
					self.game = game
					self.gameDataStoreService.save(self.game)
					completion(.success)
				}
			})
			return
		}
		
		gameNetworkService.hasUnfinishedGame(gameId: game.id) { [unowned self] (success) in
			if success {
				completion(.success)
				return
			}
			self.gameNetworkService.startNewGame(completion: { (result) in
				switch result {
				case .failure(let error):
					completion(.failure(error: error))
				case .success(let game):
					self.game = game
					completion(.success)
				}
			})
		}
	}
	
	public func setSelectedAncient(ancient: Monster) {
		game.selectedAncient = ancient
	}
	
	public func removeGame() {
		game = Game()
		gameDataStoreService.removeGame()
	}
	
//	func setNextExpedition(location: String, completion: @escaping () -> ()) {
//		if let card = self.game.currentLocationCard,
//			let index = self.game.cards.firstIndex(of: card) {
//			self.game.cards.remove(at: index)
//		}
//		self.game.cards.insert(Card(type: location), at: 0)
//		completion()
//	}
}

