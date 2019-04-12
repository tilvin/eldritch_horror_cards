//
//  Addition.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 10.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct AdditionModelContainer<T: Decodable>: Decodable {
	let data: [T]
}

struct AdditionModel {
	let id: String
	let name: String
	let description: String
	let identity: String
	var hasMap: Bool = true
	var isSelectedMap: Bool = false
	var isSelected: Bool = false
}

extension AdditionModel: Decodable {
	
	private struct Attributes: Decodable {
		let identity: String
		let name: String
		let description: String
		let hasMap: Bool
		
		enum CodingKeys: String, CodingKey {
			case identity, name, description, hasMap = "has_map"
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case id, attributes, name, description, identity, hasMap
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		let attributes = try container.decode(Attributes.self, forKey: .attributes)
		identity = attributes.identity
		name = attributes.name
		description = attributes.description
		hasMap = attributes.hasMap
	}
}
