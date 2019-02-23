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

final class CardDataProvider: CardDataProviderProtocol {
	
	private var cardNetworkService: CardNetworkServiceProtocol
	
	init(cardNetworkService: CardNetworkServiceProtocol = CardNetworkService()) {
		self.cardNetworkService = cardNetworkService
	}

	func get(gameId: Int, type: CardType, completion: @escaping (CardDataResult) -> Void) {
		cardNetworkService.get(gameId: gameId, type: type) { (result) in
			switch result {
			case .failure(let error):
				completion(.failure(error: error))
			case .localStory(let model):
				completion(.localStory(model: model))
			case .plotStory(let model):
				completion(.plotStory(model: model))
			}
		}
	}
}
