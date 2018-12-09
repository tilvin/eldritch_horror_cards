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
	case otherWorldContact = "other_world_contacts"
	case expeditionAntarctica = "expedition_location_antarctica"
	case researchAzathoth = "research_contact_azathoth"
	case americaContact = "contact_in_america"
	case europeContact = "contact_in_europe"
	case asiaAustraliaContact = "contact_in_asia_australia"
	case rlyehRisenSpesialContact = "special_contact_rlyeh_risen"
	case unknown
}

struct Card {
	let type: CardType
	
	init(type: String) {
		self.type = CardType(rawValue: type) ?? .unknown
	}
}
