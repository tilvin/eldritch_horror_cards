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
            print("Something went wrong")
        }
        
        let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent("monsters/monsters.json")
         guard let data = try? Data(contentsOf: destinationFileUrl, options: .alwaysMapped) else {
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
