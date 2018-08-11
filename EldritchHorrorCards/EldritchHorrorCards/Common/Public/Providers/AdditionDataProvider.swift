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
	func load(completion: @escaping (Bool) -> Void)
}

class AdditionDataProvider: AdditionDataProviderProtocol {
	var additions: [Addition] = []
	
	func load(completion: @escaping (Bool) -> Void){
		guard let path = Bundle.main.path(forResource: "additions", ofType: "json"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
				print("can't parse json!")
				return
		}
		if let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) {
			DI.providers.resolve(DataParseServiceProtocol.self)!.parse(type: [Addition].self, json: json) { [weak self] (result) in
				if let value = result {
					self?.additions = value
					completion(true)
				}
			}
		}
		else {
			print("Invalid serialize data")
			completion(false)
		}
	}		
}
