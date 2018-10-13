//
//  StoryCard.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct Expedition: Codable {
	let initialEffect: String?
	let passEffect: String?
	let failEffect: String?
	
	enum CodingKeys: String, CodingKey {
		case initialEffect = "initial_effect"
		case passEffect = "pass_effect"
		case failEffect = "fail_effect"
	}	
}

