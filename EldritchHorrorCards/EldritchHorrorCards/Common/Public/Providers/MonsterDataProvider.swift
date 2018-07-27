//
//  MosterDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
import Fakery

protocol MonsterDataProviderProtocol {
    var monsters: [Monster] { get set }
    func load(completion: @escaping (Bool) -> Void)
}

class MonsterDataProvider: MonsterDataProviderProtocol {
    var monsters: [Monster] = []
    
    func load(completion: @escaping (Bool) -> Void) {
        guard let path = Bundle.main.path(forResource: "monsters", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
                print("can't parse json!")
                return
        }
        
        Log.writeLog(logLevel: .debug, message: "Json parsed... \(data)")
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers]) {
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
            Log.writeLog(logLevel: .error, message: "Invalid serialize data \(data)")
            completion(false)
        }
    }
    
}
