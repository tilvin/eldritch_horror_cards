//
//  Card.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/2/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

enum CardViewType {
	case locationStory
	case plotStory
}

enum CardType: String {
	case general = "general_contacts"
	case otherWorldContact = "other_world_contacts"
	
	case expeditionAntarctica = "expedition_location_antarctica"
	case expeditionAmazonia = "expedition_location_amazonia"
	case expeditionHimalayas = "expedition_location_himalayas"
	case expeditionTunguska = "expedition_location_tunguska"
	case expeditionAfrica = "expedition_location_heart_of_africa"
	case expeditionPyramid = "expedition_location_pyramid"
	case expeditionBuenosAires = "expedition_location_buenos_aires"
	case expeditionIstanbul = "expedition_location_istanbul"
	case expeditionTokyo = "expedition_location_tokyo"
	case expeditionRoma = "expedition_location_rome"
	case expeditionArkham = "expedition_location_arkham"
	case expeditionSydney = "expedition_location_sydney"
	
	case americaContact = "contact_in_america"
	case europeContact = "contact_in_europe"
	case mountainsContact = "contact_in_mountains"
	case miskatonicExpeditionContact = "contact_in_miskatonic_expedition"
	case asiaAustraliaContact = "contact_in_asia_australia"
	case egyptContact = "contact_in_egypt"
	case africaeContact = "contact_in_africa"
	
	case yigResearchContact = "research_contact_yig"
	case knyanUnearthedSpecialContact = "special_contact_knyan_unearthed"
	case ithaquaResearchContact = "research_contact_ithaqua"
	case exploringHyperboreaSpecialContact = "special_contact_ exploring_hyperborea"
	case elderThingsResearchContact = "research_contact_elder_things"
	case darkGodSpecialContact = "special_contact_dark_god"
	case mysteriousDisappearancesSpecialContact = "special_contact_mysterious_disappearances"
	case yogSothothResearchContact = "research_contact_yog-sothoth"
	case keyAndGateSpecialContact = "special_contact_the_key_and_the_gate"
	case voidBetweenWorldsSpecialContact = "special_contact_void_between_worlds"
	case nephrenkaResearchContact = "research_contact_nephren-ka"
	case darkPharaohSpecialContact = "special_contact_dark_pharaoh"
	case blackWindSpecialContact = "special_contact_the_black_wind"
	case azathothResearchContact = "research_contact_azathoth"
	case cthulhuResearchContact = "research_contact_cthulhu"
	case rlyehRisenSpecialContact = "special_contact_rlyeh_risen"
	case abhothResearchContact = "research_contact_abhoth"
	case deepCavernsSpecialContact = "special_contact_deep_caverns"
	case spawnOfAbhothSpecialContact = "special_contact_spawn_of_abhoth"
	case shubNiggurathResearchContact = "research_contact_shub-niggurath"
	case hasturResearchContact = "research_contact_hastur"
	case citiesOnLakeSpecialContact = "special_contact_cities_on_the_lake"
	case unspeakableOneSpecialContact = "special_contact_unspeakable_one"
	case kingInYellowSpecialContact = "special_contact_king_in_yellow"
	
	case unknown
	
	var viewType: CardViewType {
		switch self {
		case .general, .americaContact, .europeContact, .mountainsContact, .miskatonicExpeditionContact, .asiaAustraliaContact, .egyptContact, .africaeContact, .yigResearchContact, .ithaquaResearchContact, .elderThingsResearchContact, .yogSothothResearchContact, .nephrenkaResearchContact, .azathothResearchContact, .cthulhuResearchContact, .abhothResearchContact, .shubNiggurathResearchContact, .hasturResearchContact:
			return .locationStory
		case .otherWorldContact, .expeditionAntarctica, .expeditionAmazonia, .expeditionHimalayas, .expeditionTunguska, .expeditionAfrica, .expeditionPyramid, .expeditionBuenosAires, .expeditionIstanbul, .expeditionTokyo, .expeditionRoma, .expeditionArkham, .expeditionSydney, .knyanUnearthedSpecialContact, .exploringHyperboreaSpecialContact, .darkGodSpecialContact, .mysteriousDisappearancesSpecialContact, .keyAndGateSpecialContact, .voidBetweenWorldsSpecialContact, .darkPharaohSpecialContact, .blackWindSpecialContact, .rlyehRisenSpecialContact, .deepCavernsSpecialContact, .spawnOfAbhothSpecialContact, .citiesOnLakeSpecialContact, .unspeakableOneSpecialContact, .kingInYellowSpecialContact:
			return .plotStory
		case .unknown:
			fatalError()
		}
	}
}

struct Card {
	let type: CardType
	
	init(type: String) {
		self.type = CardType(rawValue: type) ?? .unknown
	}
}
