//
//  Addition.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 10.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct Addition: Codable {
	let id: String
	let name: String
	let description: String
	let isMap: Bool
	var isSelectedMap: Bool = false
	var isSelected: Bool = false
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case name = "name"
		case description = "description"
		case isMap = "is_map"
	}
}
