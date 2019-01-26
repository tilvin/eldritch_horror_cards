//
//  CardDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/25/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import Foundation

protocol CardsCollectionDataProviderProtocol {
	var cards: [Card] { get set }
	func load(gameId: Int, completion: @escaping (Bool) -> Void)
}

final class CardsCollectionDataProvider: NSObject, CardsCollectionDataProviderProtocol {
	var cards: [Card] = []
	
	lazy var session: URLSession = {
		return URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
	}()
	
	private var dataTask: URLSessionDataTask?
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	private var gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
	
	//MARK: - Public
	
	override init() {
		super.init()
		loadCards()
	}
	
	func load(gameId: Int, completion: @escaping (Bool) -> Void) {
		dataTask?.cancel()
		dataTask = session.dataTask(with: APIRequest.cards(gameId: gameId).request) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
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
			
			DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: [String].self, data: data) { [unowned self] (result) in
				guard let values = result else {
					completion(false)
					return
				}
				var dict: [String: Any] = [:]
				values.forEach { dict[$0] = "" }
				
				self.cards = Array(dict.keys).map { return Card(type: $0) }
				self.gameProvider.game.setCardTypes(cardTypes: self.cards)
				completion(true)
				return
			}
		}
		dataTask?.resume()
	}
	
	//MARK: - Private
	
	private func loadCards() {
		guard !gameProvider.isNewGame else {
			cards = []
			return
		}
		cards = gameProvider.game.cardTypesAsString().map { return Card(type: $0) }
	}
}

extension CardsCollectionDataProvider: URLSessionDelegate {
	
	func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
		let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
		completionHandler(.useCredential, urlCredential)
	}
}
