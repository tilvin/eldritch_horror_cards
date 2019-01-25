//
//  MosterDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

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
		dataTask = session.dataTask(with: APIRequest.ancients(gameId: gameId).request) { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
			guard let sSelf = self else { return }
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
			
			guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) as? [[String: Any]],
				let jsonObject = jsonData else { return }
			
			let model = Mapper<Monster>().mapArray(JSONArray: jsonObject)
			let realm = try! Realm()
			
			try! realm.write {
				realm.add(model, update: true)
			}
			sSelf.monsters = Array(realm.objects(Monster.self))
			completion(sSelf.monsters.count > 0)
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
