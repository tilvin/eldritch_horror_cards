//
//  AdditionDataProviderTests.swift
//  EldritchHorrorCardsTests
//
//  Created by Andrey Torlopov on 2/3/19.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import XCTest
@testable import EldritchHorrorCards

class AdditionDataProviderTests: XCTestCase {

	var sut: AdditionDataProviderProtocol!
	
    override func setUp() {
        super.setUp()
		sut = AdditionDataProvider()
    }

    override func tearDown() {
		sut = nil
        super.tearDown()
    }
	
	func testFoo() {
		
	}
}
