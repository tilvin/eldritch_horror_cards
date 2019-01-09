//
//  Addition.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 10.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct Addition: Codable {
	let id: Int
	let name: String
	let description: String
	let identity: String
	var isMap: Bool = true
	var isSelectedMap: Bool = false
	var isSelected: Bool = false
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description
		case identity
	}
}
