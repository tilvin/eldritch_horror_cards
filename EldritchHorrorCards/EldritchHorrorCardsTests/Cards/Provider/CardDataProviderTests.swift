//
//  CardDataProviderTests.swift
//  EldritchHorrorCardsTests
//
//  Created by Andrey Torlopov on 12/2/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import XCTest
@testable import EldritchHorrorCards

class CardDataProviderTests: XCTestCase {
	var sut: CardsCollectionDataProvider!
	
    override func setUp() {
        super.setUp()
		sut = CardsCollectionDataProvider()
    }

    override func tearDown() {
        sut = nil
		super.tearDown()
    }
	
	func testSessionIsNotNil() {
		XCTAssertNotNil(sut.session)
	}
	
	//TODO: тесты для проверки метода load()
}
