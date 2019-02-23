//
//  AdditionNetworkService.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 23/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol AdditionNetworkServiceProtocol {
	func load(completion: @escaping (AdditionNetworkServiceLoadResult) -> Void)
	func selectAdditions(gameId: Int, additions: [String], maps: [String], completion: @escaping (AdditionNetworkServiceSelectResult) -> Void)
}

enum AdditionNetworkServiceLoadResult {
	case success([Addition])
	case failure(error: NetworkErrorModel)
}

enum AdditionNetworkServiceSelectResult {
	case success
	case failure(error: NetworkErrorModel)
}

final class AdditionNetworkService: NSObject, AdditionNetworkServiceProtocol {

	//MARK: - Private variables
	
	private lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	//MARK: - Public
	
	func load(completion: @escaping (AdditionNetworkServiceLoadResult) -> Void) {
		let dataTask = session.dataTask(with: APIRequest.gameSets.request) { (data: Data?, response: URLResponse?, _: Error?) -> Void in
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion(.failure(error: NetworkErrorModel(message: String(.cantGetAdditionData))))
				return
			}
			guard HTTPResponse.status == .ok else {
				completion(.failure(error: NetworkErrorModel(message: String(.httpStatusCodeError))))
				return
			}
			
			let parser = DI.providers.resolve(DataParseServiceProtocol.self)!
			parser.parse(type: [Addition].self, data: data) { result in
				if let value = result {
					completion(.success(value))
				}
			}
		}
		dataTask.resume()
	}
	
	func selectAdditions(gameId: Int, additions: [String], maps: [String], completion: @escaping (AdditionNetworkServiceSelectResult) -> Void) {
		let dataTask = session.dataTask(with: APIRequest.selectGameSets(gameId: gameId, addons: additions, maps: maps).request) { (_: Data?, response: URLResponse?, error: Error?) -> Void in
			if let error = error {
				completion(.failure(error: NetworkErrorModel(message: "\(String(.cantSelectAdditions))\n\(error.localizedDescription)" )))
				return
			}
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			if HTTPResponse.status == .ok {
				completion(.success)
			}
			else {
				completion(.failure(error: NetworkErrorModel(message: String(.httpStatusCodeError))))
			}
		}
		dataTask.resume()
	}
}

extension AdditionNetworkService: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
