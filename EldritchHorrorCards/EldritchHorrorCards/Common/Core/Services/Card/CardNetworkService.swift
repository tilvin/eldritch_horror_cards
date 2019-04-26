//
//  CardNetworkService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 24/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol CardNetworkServiceProtocol {
	func get(gameId: Int, type: CardType, completion: @escaping (CardServiceResult) -> Void)
}

enum CardServiceResult {
	case localStory(model: LocalStoryModel)
	case plotStory(model: PlotStoryModel)
	case failure(error: NetworkErrorModel)
}

final class CardNetworkService: NSObject, CardNetworkServiceProtocol {
	
	private lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	func get(gameId: Int, type: CardType, completion: @escaping (CardServiceResult) -> Void) {
		let dataTask = session.dataTask(with: APIRequest.getRequest(cardType: type, gameId: gameId)) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			if let error = error {
				print(error.localizedDescription)
				completion(.failure(error: NetworkErrorModel(error: error)))
				return
			}
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion(.failure(error: NetworkErrorModel(message: String(.errorNoData))))
				return
			}
			guard HTTPResponse.status == .ok else {
				completion(.failure(error: NetworkErrorModel(message: String(.unknownError))))
				return
			}
			
			switch type.viewType {
			case .locationStory:
				
				if let collection = try? JSONDecoder().decode(ModelContainer<LocalStoryModel>.self, from: data),
					let first = collection.data.first {
					completion(.localStory(model: first))
				}
				else {
					completion(.failure(error: NetworkErrorModel(message: String(.cantParseModel))))
				}
			case .plotStory:
				DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: PlotStoryModel.self, data: data) { (result) in
					if let value = result {
						completion(.plotStory(model: value))
						return
					}
					else {
						completion(.failure(error: NetworkErrorModel(message: "\(String(.cantParseModel)) :\(type)")))
					}
				}
			}
		}
		dataTask.resume()
	}
}

extension CardNetworkService: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
