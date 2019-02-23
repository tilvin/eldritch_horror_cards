//
//  CardDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/25/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import Foundation

protocol CardsCollectionDataProviderProtocol {
	func load(gameId: Int, completion: @escaping (CardsCollectionDataProviderResult) -> Void)
}

enum CardsCollectionDataProviderResult {
	case success([Card])
	case failure(error: NetworkErrorModel)
}

final class CardsCollectionDataProvider: CardsCollectionDataProviderProtocol {
	
	private var cardsCollectionNetworkService: CardsCollectionNetworkServiceProtocol
	
	//MARK: - Public
	
	init(cardsCollectionNetworkService: CardsCollectionNetworkServiceProtocol = CardsCollectionNetworkService()) {
		self.cardsCollectionNetworkService = cardsCollectionNetworkService
	}
	
	func load(gameId: Int, completion: @escaping (CardsCollectionDataProviderResult) -> Void) {
		cardsCollectionNetworkService.load(gameId: gameId) { (result) in
			switch result {
			case .failure(let error):
				completion(.failure(error: error))
			case .success(let cards):
				completion(.success(cards))
			}
		}
	}
}
 
