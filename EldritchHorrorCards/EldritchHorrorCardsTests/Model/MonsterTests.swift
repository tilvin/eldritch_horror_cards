//
//  MonsterTests.swift
//  EldritchHorrorCardsTests
//
//  Created by Andrey Torlopov on 23/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import XCTest
@testable import EldritchHorrorCards

class MonsterTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

	func testCodable() {
		let monster = Monster(id: 0, imageURLString: "url_1", name: "Foo", score: 10, desc: "Bar", tagline: "Baz")
		let monsterData = try? PropertyListEncoder().encode(monster)
		if let data = monsterData {
			let decodeMonster = try? PropertyListDecoder().decode(Monster.self, from: data)
			XCTAssertEqual(monster, decodeMonster)
		}
	}
}
