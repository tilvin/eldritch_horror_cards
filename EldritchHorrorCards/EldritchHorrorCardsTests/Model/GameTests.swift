//
//  GameTests.swift
//  EldritchHorrorCardsTests
//
//  Created by Andrey Torlopov on 23/02/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import XCTest
@testable import EldritchHorrorCards

class GameTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testCodable() {
		let monster = Monster(id: 0, imageURLString: "url_1", name: "Foo", score: 10, desc: "Bar", tagline: "Baz")
		let card = Card(type: CardType.general.rawValue)
		guard let date = Date(fromString: "22-02-2019", format: .custom("dd-MM-yyyy")) else {
			XCTFail()
			return
		}
		let game = Game(id: 1, token: "Foo", expeditionLocation: "bar_location", expireDate: date, selectedAncient: monster, cards: [card])
		let gameData = try? PropertyListEncoder().encode(game)
		guard let data = gameData else {
			XCTFail()
			return
		}
		let decodeGame = try? PropertyListDecoder().decode(Game.self, from: data)
		XCTAssertEqual(decodeGame, game)
	}
}
