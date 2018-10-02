//
//  Game.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 25/09/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct Game: Codable {
	let id: Int
	let token: String
	let expeditionLocation: String
	var tokenExpire: Bool = true
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case token = "token"
		case expeditionLocation = "expedition_location"
	}
}
