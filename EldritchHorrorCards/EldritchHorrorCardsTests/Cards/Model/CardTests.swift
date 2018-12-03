//
//  CardTests.swift
//  EldritchHorrorCardsTests
//
//  Created by Andrey Torlopov on 12/2/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import XCTest
@testable import EldritchHorrorCards

class CardTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

	func testInitCardWithType() {
		let card = Card(type: "Foo")
		XCTAssertNotNil(card)
	}
	
	func testWhenGivenTypeSetsType() {
		let card = Card(type: "general_contacts")
		XCTAssertEqual(card.type, CardType.general)
	}
}
