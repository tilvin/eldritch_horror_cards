//
//  ExpeditionDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 13/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol ExpeditionDataProviderProtocol {
	var expedition: Expedition? { get set }
	var expeditionType: String? { get set }
	func load(gameId: Int, type: String, completion: @escaping (Bool) -> Void)
}

final class ExpeditionDataProvider: NSObject, ExpeditionDataProviderProtocol {
	var expedition: Expedition?
	var expeditionType: String?
	var session: URLSession?
	private var dataTask: URLSessionDataTask?
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	
	override init() {
		super.init()
		if session == nil {
			session  = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
		}
	}
	
	func load(gameId: Int, type: String, completion: @escaping (Bool) -> Void) {
		guard let session = session else { fatalError() }
		dataTask?.cancel()
		dataTask = session.dataTask(with: APIRequest.expedition(gameId: gameId, type: type).request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			if let error = error {
				print(error.localizedDescription)
				completion(false)
				return
			}
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion(false)
				return
			}
			guard HTTPResponse.status == .ok else {
				completion(false)
				return
			}
			
			DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: Expedition.self, data: data) { [weak self] (result) in
				if let value = result {
					self?.expedition = value
					completion(true)
					return
				}
			}
		}
		dataTask?.resume()
	}
}

extension ExpeditionDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
