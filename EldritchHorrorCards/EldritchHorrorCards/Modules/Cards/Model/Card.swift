//
//  Card.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/2/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

enum CardType: String {
	case general = "general_contacts"
	case unknown
}

struct Card {
	let type: CardType
	
	init(type: String) {
		self.type = CardType(rawValue: type) ?? .unknown
	}
}
