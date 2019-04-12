//
//  AdditionDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 10.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol AdditionDataProviderProtocol {
	var additions: [AdditionModel] { get set }
	func load(completion: @escaping (AdditionDataProviderLoadResult) -> Void)
	func selectAdditions(gameId: Int, additions: [String], maps: [String], completion: @escaping (AdditionDataProviderSelectResult) -> Void)
}

enum AdditionDataProviderLoadResult {
	case success([AdditionModel])
	case failure(error: NetworkErrorModel)
}

enum AdditionDataProviderSelectResult {
	case success
	case failure(error: NetworkErrorModel)
}

final class AdditionDataProvider: AdditionDataProviderProtocol {
	var additions: [AdditionModel] = []
	var session: URLSession?
	private var dataTask: URLSessionDataTask?
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	private var additionNetworkService: AdditionNetworkServiceProtocol
	
	//MARK: - Init
	
	init(additionNetworkService: AdditionNetworkServiceProtocol = AdditionNetworkService()) {
		self.additionNetworkService = additionNetworkService
	}
	
	func load(completion: @escaping (AdditionDataProviderLoadResult) -> Void) {
		additionNetworkService.load { (result) in
			switch result {
			case .success(let additions):
				completion(.success(additions))
			case .failure(let error):
				completion(.failure(error: error))
			}
		}
	}
	
	func selectAdditions(gameId: Int, additions: [String], maps: [String], completion: @escaping (AdditionDataProviderSelectResult) -> Void) {
		additionNetworkService.selectAdditions(gameId: gameId, additions: additions, maps: maps) { (result) in
			switch result {
			case .success:
				completion(.success)
			case .failure(let error):
				completion(.failure(error: error))
			}
		}
	}
}
