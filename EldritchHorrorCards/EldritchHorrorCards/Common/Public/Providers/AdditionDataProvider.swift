//
//  AdditionDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 10.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol AdditionDataProviderProtocol {
	var additions: [Addition] { get set }
	func load(completion: @escaping ([Addition]) -> Void)
	func unloading(completion: @escaping (Bool) -> Void)
}

class AdditionDataProvider: NSObject, AdditionDataProviderProtocol {
	var additions: [Addition] = []
	var session: URLSession?
	private var dataTask: URLSessionDataTask?
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	
	func load(completion: @escaping ([Addition]) -> Void) {
		if session == nil {
			session  = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
		}
		
		dataTask?.cancel()
		
		dataTask = session!.dataTask(with: APIRequest.gameSets.request) { (data: Data?, response: URLResponse?, _: Error?) -> Void in
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion([])
				return
			}
			guard HTTPResponse.statusCode == 200 else {
				completion([])
				return
			}
			
			DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: [Addition].self, data: data) { [weak self] (result) in
				if let value = result {
					self?.additions = value
					completion(value)
					return
				}
			}
		}
		dataTask?.resume()
	}
	
	func unloading(completion: @escaping (Bool) -> Void) {
		let addons = UserDefaults.standard.object(forKey: "additions") as! [String]
		let gameId = "34"
		dataTask?.cancel()
		dataTask = session!.dataTask(with: APIRequest.selectGameSets(gameId: gameId, addons: addons).request) { (_: Data?, response: URLResponse?, _: Error?) -> Void in
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			completion(HTTPResponse.statusCode == 200)
			return
		}
		dataTask?.resume()
	}
}

extension AdditionDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
