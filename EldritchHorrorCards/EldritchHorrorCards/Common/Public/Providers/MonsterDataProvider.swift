//
//  MosterDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol MonsterDataProviderProtocol {
	func load(gameId: Int, completion: @escaping (MonsterDataProviderLoadResult) -> Void)
	func selectAncient(gameId: Int, ancient: Monster, completion: @escaping (MonsterDataProviderSelectResult) -> Void)
}

enum MonsterDataProviderLoadResult {
	case success([Monster])
	case failure(error: NetworkErrorModel)
}

enum MonsterDataProviderSelectResult {
	case success
	case failure(error: NetworkErrorModel)
}

final class MonsterDataProvider: NSObject, MonsterDataProviderProtocol {
	
	//MARK: - Private variables
	
	private var monsterNetworkService: MonsterNetworkServiceProtocol
	
	//MARK:- Init
	
	init(monsterNetworkService: MonsterNetworkServiceProtocol = MonsterNetworkService()) {
		self.monsterNetworkService = monsterNetworkService
	}
	
	//MARK: - Public
	
	func load(gameId: Int, completion: @escaping (MonsterDataProviderLoadResult) -> Void) {
		monsterNetworkService.load(gameId: gameId) { (result) in
			switch result {
			case .success(let monsters):
				completion(.success(monsters))
			case .failure(let error):
				completion(.failure(error: error))
			}
		}
	}
	
	func selectAncient(gameId: Int, ancient: Monster, completion: @escaping (MonsterDataProviderSelectResult) -> Void) {
		monsterNetworkService.selectAncient(gameId: gameId, ancient: ancient) { (result) in
			switch result {
			case .success:
				completion(.success)
			case .failure(let error):
				completion(.failure(error: error))
			}
		}
	}
}

