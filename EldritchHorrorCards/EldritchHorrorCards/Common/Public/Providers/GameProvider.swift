//
//  GamesProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 25/09/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol GameDataProviderProtocol {
	var game: Game! { get set }
	var isSessionActive: Bool { get }
	func load(completion: @escaping (Bool) -> Void)
}

class GameDataProvider: NSObject, GameDataProviderProtocol {
	
	struct Constants {
		static let idKey = "game_id_key"
		static let tokenKey = "game_token"
		static let expeditionKey = "expedition_Location"
		static let expireDateKey = "game_date"
	}
	
	//MARK: - Public variables
	
	var game: Game!
	var isSessionActive: Bool {
		return !game.token.isEmpty && !game.tokenExpire
	}
	
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
	
	public func load(completion: @escaping (Bool) -> Void) {
		dataTask?.cancel()
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
			DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: Game.self, data: data) { [weak self] (result) in
				guard let sSelf = self else {
					completion(false)
					return
				}
				if let value = result {
					sSelf.game = value
					sSelf.game.tokenExpire = false
					sSelf.userDefaultsProvider.set(key: Constants.idKey, value: value.id)
					sSelf.userDefaultsProvider.set(key: Constants.tokenKey, value: value.token)
					sSelf.userDefaultsProvider.set(key: Constants.expeditionKey, value: value.expeditionLocation)
					sSelf.userDefaultsProvider.set(key: Constants.expireDateKey, value: Date().adjust(.day, offset: 2))
					completion(true)
					return
				}
			}
		}
		dataTask?.resume()
	}
	
	private func loadLocalGame() {
		guard let id = userDefaultsProvider.get(key: Constants.idKey, type: Int.self),
			let token = userDefaultsProvider.get(key: Constants.tokenKey, type: String.self),
			let expidition = userDefaultsProvider.get(key: Constants.expeditionKey, type: String.self),
			let expireDate = userDefaultsProvider.get(key: Constants.expireDateKey, type: Date.self) else {
				game = Game.init(id: 0, token: "", expeditionLocation: "", tokenExpire: true)
				return
		}
		game = Game.init(id: id, token: token, expeditionLocation: expidition, tokenExpire: expireDate <= Date())
	}
}

extension GameDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
