//
//  AdditionTests.swift
//  EldritchHorrorCardsTests
//
//  Created by Andrey Torlopov on 2/3/19.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import XCTest
@testable import EldritchHorrorCards

class AdditionTests: XCTestCase {

	let  sut: Addition = Addition(id: 0, name: "Foo", description: "Bar", identity: "ID1", isMap: false, isSelectedMap: false, isSelected: false)
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
		super.tearDown()
    }
	
	func testInitModel() {
		XCTAssertNotNil(sut)
	}
	
	func testModel() {
		XCTAssertEqual(sut.id, 0)
		XCTAssertEqual(sut.name, "Foo")
		XCTAssertEqual(sut.description, "Bar")
		XCTAssertEqual(sut.identity, "ID1")
		XCTAssertFalse(sut.isMap)
		XCTAssertFalse(sut.isSelected)
		XCTAssertFalse(sut.isSelectedMap)
	}
}
