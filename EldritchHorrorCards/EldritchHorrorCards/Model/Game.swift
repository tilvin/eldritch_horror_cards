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

struct Game: Equatable {
	var id: Int = 0
	var token: String = ""
	var expeditionLocation: String = ""
	var expireDate: Date = Date().adjust(.day, offset: 2)
	var selectedAncient: Monster?
	var isValid: Bool { return id > 0 }
	var isSessionActive: Bool { return Date() > expireDate || token.isEmpty }
	var cards: [Card] = []
}

extension Game: Codable {
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case token = "token"
		case expeditionLocation = "expedition_location"
		case expireDate = "expireDate"
		case selectedAncient = "selectedAncient"
		case cards = "cards"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		if let value = try? values.decode(Int.self, forKey: .id) {
			self.id = value
		}
		
		if let value = try? values.decode(String.self, forKey: .token) {
			self.token = value
		}
		
		if let value = try? values.decode(String.self, forKey: .expeditionLocation) {
			self.expeditionLocation = value
		}
		
		if let value = try? values.decode(Date.self, forKey: .expireDate) {
			self.expireDate = value
		}
		
		self.selectedAncient = try? values.decode(Monster.self, forKey: .selectedAncient)
		
		if let value = try? values.decode([Card].self, forKey: .cards) {
			self.cards = value
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(token, forKey: .token)
		try container.encode(expeditionLocation, forKey: .expeditionLocation)
		try container.encode(expireDate, forKey: .expireDate)
		try container.encode(selectedAncient, forKey: .selectedAncient)
		try container.encode(cards, forKey: .cards)
	}
}

extension Game: GameProtocol {
	
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
