//
//  MosterDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
import Fakery
import Zip

protocol MonsterDataProviderProtocol {
	var monsters: [Monster] { get set }
	func load(completion: @escaping (Bool) -> Void)
}

class MonsterDataProvider: MonsterDataProviderProtocol {
	var monsters: [Monster] = []

	func load(completion: @escaping (Bool) -> Void) {
		guard let zipPath = Bundle.main.url(forResource: "monsters", withExtension: "zip"),
			  let data = try? Data(contentsOf: zipPath) else { return completion(false) }
		guard let unzipData = try? data.unzip(dataType: .monsters),
			  let unzipJsonData = unzipData,
			  let json = try? JSONSerialization.jsonObject(with: unzipJsonData, options: [JSONSerialization.ReadingOptions.mutableContainers]) else { return completion(false) }

		DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: [Monster].self, json: json) { [weak self] (result) in
			if let value = result {
				self?.monsters = value
				completion(true)
			}
		}
	}
}
