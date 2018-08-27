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
}

class AdditionDataProvider: NSObject, AdditionDataProviderProtocol {
	var additions: [Addition] = []
	var session: URLSession?
	private var dataTask: URLSessionDataTask?
	
	func load(completion: @escaping ([Addition]) -> Void){
		if session == nil {
			session  = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
		}
		
		dataTask?.cancel()
 
		dataTask = session!.dataTask(with: APIRequest.gameSets.request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			guard let data = data else {
				completion([])
				return
			}
			if HTTPResponse.statusCode == 200,
				let jsonString = String(data: data, encoding: .utf8),
				let jsonData = jsonString.data(using: .utf8) {
				DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: [Addition].self, data: jsonData) { [weak self] (result) in
					if let value = result {
						self?.additions = value
						completion(value)
						return
					}
				}
			}
			else {
				completion([])
			}
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
