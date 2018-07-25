//
//  SimpleCard.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/25/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct ShortStory: Codable {
	var title: String
	var story: String
}

struct StoryCard: Codable {
	let uid: String
	let title: String
	let story: String
	let success: String
	let failure: String
}

struct PlaceCard: Codable {
	let uid: String
	let city: String
	let wilderness: String
	let sea: String
}

enum AreaType: String, Codable {
	case asia = "asia"
	case amirica = "america"
}

struct CityCard: Codable {
	let uid: String
	let area: AreaType
	let cities: [ShortStory] = []
}

struct Decks: Codable {
	let portals: [StoryCard]
    let cities: [CityCard]
    let expeditions: [StoryCard] 
    let contacts: [PlaceCard]
    let evidences: [PlaceCard]
    let specialContacts: [StoryCard] 
}
