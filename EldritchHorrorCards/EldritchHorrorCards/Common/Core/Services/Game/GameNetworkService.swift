//
//  GameNetworkService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 23/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol GameNetworkServiceProtocol {
	func hasUnfinishedGame(gameId: Int, completion: @escaping (Bool) -> ())
	func startNewGame(completion: @escaping (GameNetworkServiceResult) -> ())
}

enum GameNetworkServiceResult {
	case success(Game)
	case failure(error: NetworkErrorModel)
}

final class GameNetworkService: NSObject, GameNetworkServiceProtocol {
	
	//MARK: - Private variables
	
	private lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	private var dataTask: URLSessionDataTask?
	
	//MARK: - Public
	
	func hasUnfinishedGame(gameId: Int, completion: @escaping (Bool) -> ()) {
		let restoreTask = session.dataTask(with: APIRequest.restoreSession(gameId: gameId).request) { (_, response: URLResponse?, _: Error?) -> Void in
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
	
	func startNewGame(completion: @escaping (GameNetworkServiceResult) -> ()) {
		dataTask?.cancel()
		dataTask = session.dataTask(with: APIRequest.games.request) { [weak self] (data: Data?, response: URLResponse?, _: Error?) -> Void in
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion(.failure(error: NetworkErrorModel(message: String(.cantGetNewGameData))))
				return
			}
			guard HTTPResponse.statusCode == 200 else {
				completion(.failure(error: NetworkErrorModel(message: "\(String(.httpStatusCodeError)) code: \(HTTPResponse.statusCode)")))
				return
			}
			
//			DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: Game.self, data: data) { (result) in
//				if let value = result {
//					completion(.success(value))
//					return
//				}
//				else {
//					completion(.failure(error: NetworkErrorModel(message: "\(String(.cantParseModel))")))
//				}
//			}
		}
		dataTask?.resume()
	}
}

extension GameNetworkService: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
