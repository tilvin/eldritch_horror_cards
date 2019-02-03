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
		super.setUp()
		
    }

    override func tearDown() {
		
		super.tearDown()
    }

	func testInitCardWithType() {
		let sut = Card(type: "Foo")
		XCTAssertNotNil(sut)
	}
	
	func testWhenGivenTypeSetsType() {
		let sut = Card(type: CardType.general.rawValue)
		XCTAssertEqual(sut.type, CardType.general)
	}
}
