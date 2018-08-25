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
	lazy private var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	private var dataTask: URLSessionDataTask?
	
	func load(completion: @escaping ([Addition]) -> Void){
		let networkService: NetworkServiceProtocol = DI.providers.resolve(NetworkServiceProtocol.self)!
		let parser: DataParseServiceProtocol = DI.providers.resolve(DataParseServiceProtocol.self)!
		
		dataTask?.cancel()
		dataTask = session.dataTask(with: APIRequest.gameSets.request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
			print(data, response, error)
			print("...")
			
			//			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			//			switch HTTPResponse.statusCode {
			//			case 200:
			//				print("ok")
			//
			//			default:
			//				completion([])
			//			}
			//
			//			guard let json = data  else {
			//				completion([])
			//				return
			//			}
			//			let parser: DataParseServiceProtocol = DI.providers.resolve(DataParseServiceProtocol.self)!
			//			parser.parse(type: [Addition].self, json: json) { [weak self] (result) in
			//				if let value = result {
			//					self?.additions = value
			//					completion(value)
			//				}
			//				else {
			//					completion([])
			//				}
			//			}
		}
		dataTask?.resume()
	}
}

extension AdditionDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!) )
	}
	
	//	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
	//
	//		//accept all certs when testing, perform default handling otherwise
	////	if webService.isTesting() {
	////		print("Accepting cert as always")
	////		completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
	////	}
	////	else {
	////		print("Using default handling")
	//		completionHandler(.performDefaultHandling, URLCredential(trust: challenge.protectionSpace.serverTrust!))
	////	}
	//	}
	
}


