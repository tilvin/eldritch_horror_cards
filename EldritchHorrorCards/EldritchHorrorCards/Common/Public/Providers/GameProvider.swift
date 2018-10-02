//
//  GamesProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 25/09/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol GameDataProviderProtocol {
	var game: Game? { get set }
	func load(completion: @escaping (Bool) -> Void)
}

class GameDataProvider: NSObject, GameDataProviderProtocol {
	
	struct Constants {
		static let gameIdKey = "game_id_key"
		static let gameToken = "game_token"
		static let expeditionLocation = "expedition_Location"
		static let gameDate = "game_date"
	}
	
	//MARK: - Public variables
	
	var game: Game?
	
	//MARK: - Private variables
	
	private lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	private var dataTask: URLSessionDataTask?
	
	func load(completion: @escaping (Bool) -> Void) {
		
		dataTask?.cancel()
		dataTask = session.dataTask(with: APIRequest.games(user_uid: "1").request) { (data: Data?, response: URLResponse?, _: Error?) -> Void in
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
				if let value = result {
					self?.game = value
					guard let game = self!.game else { completion(false)
						return
					}
					UserDefaults.standard.set(game.id, forKey: Constants.gameIdKey)
					UserDefaults.standard.set(game.token, forKey: Constants.gameToken)
					UserDefaults.standard.set(game.expeditionLocation, forKey: Constants.expeditionLocation)
					UserDefaults.standard.set(Date(timeIntervalSinceNow: 172800), forKey: Constants.gameDate)
					completion(true)
					return
				}
			}
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
