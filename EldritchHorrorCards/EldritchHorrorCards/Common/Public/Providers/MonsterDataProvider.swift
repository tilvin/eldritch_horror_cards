//
//  MosterDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol MonsterDataProviderProtocol {
	var monsters: [Monster] { get set }
	var selectedAncient: Monster? { get set }
	
	func load(gameId: Int, completion: @escaping (Bool) -> Void)
	func selectAncient(gameId: Int, ancient: Monster, completion: @escaping (Bool) -> Void)
}

final class MonsterDataProvider: NSObject, MonsterDataProviderProtocol {
	
	//MARK:- Public variables
	
	var monsters: [Monster]  = []
	var session: URLSession?
	var selectedAncient: Monster?
	
	//MARK: - Private variables
	
	private var dataTask: URLSessionDataTask?
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	
	//MARK:- Init
	
	override init() {
		super.init()
		if session == nil {
			session  = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
		}
	}
	
	//MARK: - Public
	
	func load(gameId: Int, completion: @escaping (Bool) -> Void) {
		guard let session = session else { fatalError() }
		dataTask?.cancel()
		dataTask = session.dataTask(with: APIRequest.ancients(gameId: gameId).request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
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
				print(HTTPResponse.statusCode)
				completion(false)
				return
			}
			
			DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: [Monster].self, data: data) { [weak self] (result) in
				if let value = result {
					self?.monsters = value
					completion(true)
					return
				}
			}
		}
		dataTask?.resume()
	}
	
	func selectAncient(gameId: Int, ancient: Monster, completion: @escaping (Bool) -> Void) {
		guard let session = session else { fatalError() }
		selectedAncient = ancient
		
		dataTask?.cancel()
		dataTask = session.dataTask(with: APIRequest.selectAncient(gameId: gameId, ancient: ancient.id).request) { (_: Data?, response: URLResponse?, error: Error?) -> Void in
			if let error = error {
				print(error.localizedDescription)
				completion(false)
				return
			}
			guard let HTTPResponse = response as? HTTPURLResponse else { return }
			completion(HTTPResponse.status == .ok)
			return
		}
		dataTask?.resume()
	}
}

extension MonsterDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
