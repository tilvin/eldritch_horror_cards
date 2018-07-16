//
//  MosterDataProvider.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
import Fakery

protocol MosterDataProviderProtocol {
	var mosters: [Monster] { get set }
	func load()
}

class MosterDataProvider: MosterDataProviderProtocol {
	var mosters: [Monster] = []
	
	func load() {
		guard let path = Bundle.main.path(forResource: "monsters", ofType: "json"),
			let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped) else {
				print("can't parse json!")
				return
		}
		
		let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.mutableContainers])
		Log.writeLog(logLevel: .debug, message: "Json parsed... \(json)")
		//TODO: use parse service!
		
		let faker = Faker()
		let urls = ["https://i.pinimg.com/564x/c0/7e/c0/c07ec05cac80e099374f30c2f646b7be.jpg",
					"https://i.pinimg.com/564x/ba/57/2a/ba572a66a1e61809e16ca9d1c5eca3d7.jpg",
					"https://i.pinimg.com/564x/e3/69/35/e36935a809f267e4cdfbfbdca77fed44.jpg",
					"https://i.pinimg.com/564x/d4/a3/b0/d4a3b0bf8de28c5b9bc46fdda6e5be63.jpg",
					"https://i.pinimg.com/564x/17/ed/8f/17ed8f43cfc10fb58e421ec58d4d13a4.jpg",
					"https://i.pinimg.com/564x/4a/75/82/4a75823f9749871596d3dd374305f0a3.jpg",
					"https://i.pinimg.com/564x/72/6d/66/726d668ef6cef76e5f2e9c33d9e827a7.jpg",
					"https://i.pinimg.com/564x/c4/83/6b/c4836bbdbee9b54a63385ce4c305dba6.jpg",
					"https://i.pinimg.com/564x/a3/94/fc/a394fcd0a59ecd0d809a73d7e7691fd3.jpg",
					"https://i.pinimg.com/564x/a3/94/fc/a394fcd0a59ecd0d809a73d7e7691fd3.jpg",
					"https://i.pinimg.com/564x/f6/3e/6a/f63e6aab699d121d86c0e0dd8ec4e869.jpg",
					"https://i.pinimg.com/564x/dc/4e/19/dc4e19cf51c7ea9ebb24a35a39e78446.jpg",
					"https://i.pinimg.com/564x/e6/10/bc/e610bc6e3fed833744470c5adc36ee91.jpg",
					"https://i.pinimg.com/564x/2a/84/05/2a8405ac23f1d6136a5b9ad2171b972a.jpg",
					"https://i.pinimg.com/564x/54/c4/e0/54c4e0e4e535a88ca0f4ed15dc852268.jpg",
					"https://i.pinimg.com/564x/f6/6b/0d/f66b0d6a47012fdef19084e73e983062.jpg",
					"https://i.pinimg.com/564x/4e/04/9e/4e049ef5f46ab895fd2002412194af69.jpg",
					"https://i.pinimg.com/564x/58/0b/d5/580bd5fd213ee93e7a2b84af93efb34f.jpg",
					"https://i.pinimg.com/564x/d4/d3/3a/d4d33a346d294ec12acec7da856d7781.jpg"]
        self.mosters = []
        for url in urls {
            self.mosters.append(Monster(name: faker.lorem.words(amount:2),
                                         imageURLString: url,
                                         detail: faker.lorem.words(amount: faker.number.randomInt(min: 2, max: 6)),
                                         score: faker.number.randomInt(min: 10, max: 16)))
        }
	}
}
