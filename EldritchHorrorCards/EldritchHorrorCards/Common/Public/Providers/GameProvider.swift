//
//  GamesProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 25/09/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol GameDataProviderProtocol {
	var game: GameProtocol { get set }
	var isNewGame: Bool { get }
	func loadGame(completion: @escaping (Bool) -> Void)
	func setSelectedAncient(ancient: Monster)
	func removeGame()
	func setNextExpedition(location: String, completion: @escaping () -> ())
}

class GameDataProvider: NSObject, GameDataProviderProtocol {
	
	private struct Constants {
		static let idKey = "game_id_key"
		static let tokenKey = "game_token"
		static let expeditionKey = "expedition_Location"
		static let expireDateKey = "game_date"
		static let gameStoreKey = "game_store_key"
		static let gameObjectKey = "game_object_key"
	}
	
	//MARK: - Public variables
	
	var game: GameProtocol = Game()
	var isNewGame: Bool { return isNewGameFlag }
	
	//MARK: - Private variables
	
	private lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	private var dataTask: URLSessionDataTask?
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	private var isNewGameFlag: Bool = true
	private let persistentService = DI.providers.resolve(PersistentServiceProtocol.self)!
	
	//MARK: - Public
	
	override init() {
		super.init()
		loadLocalGame()
	}
	
	public func loadGame(completion: @escaping (Bool) -> Void) {
		guard game.isValid else {
			getNewGameId(completion: { (success) in
				completion(success)
			})
			return
		}
		
		restoreSession { [unowned self] (success) in
			if success {
				self.isNewGameFlag = false
				completion(true)
				return
			}
			
			self.getNewGameId(completion: { (success) in
				completion(success)
			})
		}
	}
	
	public func setSelectedAncient(ancient: Monster) {
		game.selectedAncient = ancient
	}
	
	public func removeGame() {
//		persistentService.save(objects: nil, for: Constants.gameStoreKey)
		game = Game()
		isNewGameFlag = true
		loadLocalGame()
	}

	func setNextExpedition(location: String, completion: @escaping () -> ()) {
		self.game.updateExpedition(location: location, completion: completion)
	}
	
	//MARK: - Private
	
	private func loadLocalGame() {
		let result = persistentService.get(type: .game)
		switch result {
		case .game(let game):
			self.game = game
		case .failure(let message):
			print("error with message: \(message)")
		default:
			break
		}
	}
	
	func restoreSession(completion: @escaping (Bool) -> ()) {
		guard game.isValid else { return }
		let restoreTask = session.dataTask(with: APIRequest.restoreSession(gameId: game.id).request) { (_, response: URLResponse?, _: Error?) -> Void in
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			//TODO: убрать хардкод 200.
			guard HTTPResponse.statusCode == 200 else {
				completion(false)
				return
			}
			completion(true)
		}
		restoreTask.resume()
	}
	
	private func getNewGameId(completion: @escaping (Bool) -> ()) {
		dataTask?.cancel()
	
		//TODO: load from storage?
//		game = realm.objects(Game.self).first
		if game.isValid {
			completion(true)
			return
		}
		
		dataTask = session.dataTask(with: APIRequest.games.request) { [weak self] (data: Data?, response: URLResponse?, _: Error?) -> Void in
			guard let sSelf = self else { return }
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion(false)
				return
			}
			guard HTTPResponse.statusCode == 200 else {
				completion(false)
				return
			}
			
			guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) as? [String: Any],
				let jsonObject = jsonData else { return }
			//TODO: parse
//				let model = Mapper<Game>().map(JSON: jsonObject) else { return }
			
			
//			try! realm.write {
//				realm.delete(realm.objects(Game.self))
//				realm.add(model, update: true)
//				completion(true)
//			}
//			sSelf.game = realm.objects(Game.self).first
		}
		dataTask?.resume()
	}
}

extension GameDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
