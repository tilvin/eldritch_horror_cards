//
//  CardsViewControllerTests.swift
//  EldritchHorrorCardsTests
//
//  Created by Andrey Torlopov on 12/1/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import XCTest
@testable import EldritchHorrorCards

class CardsViewControllerTests: XCTestCase {
	var sut: CardsViewController!
	
    override func setUp() {
        super.setUp()
		sut = CardsViewController()
		sut.loadViewIfNeeded()
		sut.beginAppearanceTransition(true, animated: true)
		sut.endAppearanceTransition()
    }

    override func tearDown() {
		sut = nil
        super.tearDown()
    }
	
	func testWhenViewIsLoadedNavigatorBarIsHidden() {
		XCTAssertTrue(sut.isHiddenNavigationBar)
	}
	
	func testWhenViewIsLoadedBottomBarIsHidden() {
		XCTAssertTrue(sut.hidesBottomBarWhenPushed)
	}
	
	func testLoadedViewIsCardsView() {
		XCTAssertTrue(sut.view is CardsView)
	}
}
