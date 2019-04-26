//
//  CardsNetworkProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 24/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol CardsCollectionNetworkServiceProtocol {
	func load(gameId: Int, completion: @escaping (CardsCollectionNetworkServiceResult) -> Void)
}

enum CardsCollectionNetworkServiceResult {
	case success([Card])
	case failure(error: NetworkErrorModel)
}

final class CardsCollectionNetworkService: NSObject, CardsCollectionNetworkServiceProtocol {
	
	lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	func load(gameId: Int, completion: @escaping (CardsCollectionNetworkServiceResult) -> Void) {
		let dataTask = session.dataTask(with: APIRequest.cards(gameId: gameId).request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			if let error = error {
				completion(.failure(error: NetworkErrorModel(error: error)))
				return
			}
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion(.failure(error: NetworkErrorModel(message: String(.cantGetCardsCollection))))
				return
			}
			guard HTTPResponse.status == .ok else {
				completion(.failure(error: NetworkErrorModel(message: String(.httpStatusCodeError))))
				return
			}
			
			let parser = DI.providers.resolve(DataParseServiceProtocol.self)!
			parser.parse(type: [String].self, data: data) { result in
				guard let values = result else {
					completion(.failure(error: NetworkErrorModel(message: "\(String(.cantParseModel))")))
					return
				}
//				var dict: [String: Any] = [:]
//				values.forEach { dict[$0] = "" }
//
				let cards = values.map { return Card(type: $0) }
				completion(.success(cards))
			}
		}
		dataTask.resume()
	}
}

extension CardsCollectionNetworkService: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
