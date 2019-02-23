//
//  ExpeditionDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 13/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

enum CardDataResult {
	case localStory(model: LocalStoryModel)
	case plotStory(model: PlotStoryModel)
	case failure(error: NetworkErrorModel)
}

protocol CardDataProviderProtocol {
	func get(gameId: Int, type: CardType, completion: @escaping (CardDataResult) -> Void)
}

final class CardDataProvider: NSObject, CardDataProviderProtocol {
	var session: URLSession?
	private var dataTask: URLSessionDataTask?
	
	override init() {
		super.init()
		if session == nil {
			session  = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
		}
	}

	func get(gameId: Int, type: CardType, completion: @escaping (CardDataResult) -> Void) {
		guard let session = session else { fatalError() }
		dataTask?.cancel()
		
		dataTask = session.dataTask(with: APIRequest.getRequest(cardType: type, gameId: gameId)) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
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
				DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: LocalStoryModel.self, data: data) { (result) in
					if let value = result {
						completion(.localStory(model: value))
						return
					}
					else {
						completion(.failure(error: NetworkErrorModel(message: "\(String(.cantParseModel)) :\(type)")))
					}
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
		dataTask?.resume()
	}
}

extension CardDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
