//
//  Game.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 25/09/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

protocol GameProtocol {
	var id: Int { get set }
	var token: String { get set }
	var expeditionLocation: String { get set }
	var isSessionActive: Bool { get }
	var isValid: Bool { get }
	var selectedAncient: Monster? { get set }
	func cardTypesAsString() -> [String]
	mutating func setCardTypes(cardTypes: [Card])
	mutating func updateExpedition(location: String, completion: @escaping () -> ())
}

struct Game {
	var id: Int = 0
	var token: String = ""
	var expeditionLocation: String = ""
	var expireDate: Date = Date().adjust(.day, offset: 2)
	var selectedAncient: Monster?
	var isValid: Bool { return id > 0 }
	
	var isSessionActive: Bool {
		return Date() > expireDate || token.isEmpty
	}
	
	var cards: [Card] = []
	
	mutating func setCardTypes(cardTypes: [Card]) {
		cards = cardTypes
	}
	
	func cardTypesAsString() -> [String] {
		return self.cards.map { $0.type.rawValue }
	}

	mutating func updateExpedition(location: String, completion: @escaping () -> ()) {
		if let index = self.cards.firstIndex(where: { (card) -> Bool in
			return card.type.rawValue == self.expeditionLocation
		}) {
			self.cards.remove(at: index)
		}
		self.cards.insert(Card(type: location), at: 0)
		completion()
	}
}

extension Game: GameProtocol {}
