//
//  StoryCard.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct StoryCard: Codable {
	let uid: String
	let title: String
	let story: String
	let success: String
	let failure: String
}
