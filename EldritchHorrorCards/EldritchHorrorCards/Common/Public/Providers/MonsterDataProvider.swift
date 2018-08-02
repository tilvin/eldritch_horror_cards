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
		do {
			let filePath = Bundle.main.url(forResource: "monsters", withExtension: "zip")!
			let file = try Zip.quickUnzipFile(filePath)
			Log.writeLog(logLevel: .debug, message: "Zip... \(file)")
		}
		catch {
			print("Something went wrong with unzip monsters.zip")
			completion(false)
		}
		let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first as URL?)!
		let destinationFileUrl = documentsUrl.appendingPathComponent("monsters/monsters.json")
		if let data = try? Data(contentsOf: destinationFileUrl, options: .alwaysMapped),
			let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) {
			Log.writeLog(logLevel: .debug, message: "Json parsed... \(data)")
			let jsonMonsters = DataParseService().parse(type: .monster, json: json)
			switch jsonMonsters {
			case .monsters(let monsters):
				self.monsters = monsters
				completion(true)
			case .error(let error):
				Log.writeLog(logLevel: .error, message: error)
				completion(false)
			default: break
			}
		}
		else {
			Log.writeLog(logLevel: .error, message: "Invalid serialize data monsters.json")
			completion(false)
		}
	}
}
