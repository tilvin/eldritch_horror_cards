//
//  MonsterNetworkService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 23/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol MonsterNetworkServiceProtocol {
	func load(gameId: Int, completion: @escaping (MonsterNetworkServiceLoadResult) -> Void)
	func selectAncient(gameId: Int, ancient: Monster, completion: @escaping (MonsterNetworkServiceSelectResult) -> Void)
}

enum MonsterNetworkServiceLoadResult {
	case success([Monster])
	case failure(error: NetworkErrorModel)
}

enum MonsterNetworkServiceSelectResult {
	case success
	case failure(error: NetworkErrorModel)
}



final class MonsterNetworkService: NSObject, MonsterNetworkServiceProtocol {
	
	//MARK: - Private variables
	
	private lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	//MARK: - Public
	
	func load(gameId: Int, completion: @escaping (MonsterNetworkServiceLoadResult) -> Void) {
		let dataTask = session.dataTask(with: APIRequest.ancients(gameId: gameId).request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			if let error = error {
				completion(.failure(error: NetworkErrorModel(error: error)))
				return
			}
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion(.failure(error: NetworkErrorModel(message: String(.cantGetMonsterData))))
				return
			}
			guard HTTPResponse.status == .ok else {
				completion(.failure(error: NetworkErrorModel(message: String(.httpStatusCodeError))))
				return
			}
			
			let parser = DI.providers.resolve(DataParseServiceProtocol.self)!
			parser.parse(type: [Monster].self, data: data) { result in
				if let value = result {
					completion(.success(value))
				}
				else {
					completion(.failure(error: NetworkErrorModel(message: "\(String(.cantParseModel))")))
				}
			}
		}
		dataTask.resume()
	}
	
	func selectAncient(gameId: Int, ancient: Monster, completion: @escaping (MonsterNetworkServiceSelectResult) -> Void) {
		let dataTask = session.dataTask(with: APIRequest.selectAncient(gameId: gameId, ancient: ancient.id).request) { (_: Data?, response: URLResponse?, error: Error?) -> Void in
			if let error = error {
				completion(.failure(error: NetworkErrorModel(error: error)))
				return
			}
			guard let _ = response as? HTTPURLResponse else {
				completion(.failure(error: NetworkErrorModel(message: String(.httpStatusCodeError))))
				return
			}
			completion(.success)
		}
		dataTask.resume()
	}
}

extension MonsterNetworkService: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
