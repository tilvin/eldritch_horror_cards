//
//  GamesProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 25/09/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
import ObjectMapper
import ObjectMapper_Realm
import RealmSwift

protocol GameDataProviderProtocol {
	var game: GameProtocol! { get set }
	var isNewGame: Bool { get }
	func loadGameId(completion: @escaping (Bool) -> Void)
}

class GameDataProvider: NSObject, GameDataProviderProtocol {
	
	struct Constants {
		static let idKey = "game_id_key"
		static let tokenKey = "game_token"
		static let expeditionKey = "expedition_Location"
		static let expireDateKey = "game_date"
	}
	
	//MARK: - Public variables
	
	var game: GameProtocol!
	var isNewGame: Bool { return isNewGameFlag }
	
	//MARK: - Private variables
	
	private lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	private var dataTask: URLSessionDataTask?
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	private var isNewGameFlag: Bool = true
	
	//MARK: - Public
	
	override init() {
		super.init()
		loadLocalGame()
	}
	
	public func loadGameId(completion: @escaping (Bool) -> Void) {
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
	
	//MARK: - Private
	
	private func loadLocalGame() {
		let realm = try! Realm()
		if realm.objects(Game.self).count == 0 {
			try! realm.write {
				realm.add(Game(), update: true)
			}
		}
		game = realm.objects(Game.self).first
	}
	
	func restoreSession(completion: @escaping (Bool) -> ()) {
		guard game.isValid else { return }
		let restoreTask = session.dataTask(with: APIRequest.restoreSession(gameId: game.id).request) { (_, response: URLResponse?, _: Error?) -> Void in
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
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
		let realm = try! Realm()
		game = realm.objects(Game.self).first
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
				let jsonObject = jsonData,
				let model = Mapper<Game>().map(JSON: jsonObject) else { return }
			
			let realm = try! Realm()
			try! realm.write {
				realm.delete(realm.objects(Game.self))
				realm.add(model, update: true)
				completion(true)
			}
			sSelf.game = realm.objects(Game.self).first
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
