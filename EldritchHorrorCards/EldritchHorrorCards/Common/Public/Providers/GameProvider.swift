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
	var game:Game?
	var session: URLSession?
	private var dataTask: URLSessionDataTask?
	
	func load(completion: @escaping (Bool) -> Void) {
		if session == nil {
			session  = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
		}
		
		dataTask?.cancel()
		
		dataTask = session!.dataTask(with: APIRequest.games(user_uid: "1").request) { (data: Data?, response: URLResponse?, _: Error?) -> Void in
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
					UserDefaults.standard.set(game.id, forKey: "gameId")
					UserDefaults.standard.set(game.token, forKey: "gameToken")
					UserDefaults.standard.set(game.expeditionLocation, forKey: "expeditionLocation")
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
