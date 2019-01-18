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
	
	//MARK: - Private variables
	
	private lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	private var dataTask: URLSessionDataTask?
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	
	//MARK: - Public
	
	override init() {
		super.init()
		loadLocalGame()
	}
	
	public func loadGameId(completion: @escaping (Bool) -> Void) {
		dataTask?.cancel()
		
		let realm = try! Realm()
		guard realm.objects(Game.self).count == 0 else {
			self.game = realm.objects(Game.self).last
			completion(true)
			return
		}
		
		dataTask = session.dataTask(with: APIRequest.games.request) { (data: Data?, response: URLResponse?, _: Error?) -> Void in
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
			
			self.game = model
			let realm = try! Realm()
			try! realm.write {
				realm.add(model, update: true)
				completion(true)
			}
		}
		dataTask?.resume()
	}
	
	private func loadLocalGame() {
		let realm = try! Realm()
		if realm.objects(Game.self).count == 0 {
			try! realm.write {
				realm.add(Game(), update: true)
			}
		}
		
		self.game = realm.objects(Game.self).first
	}
}

extension GameDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
