//
//  Moster.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct MonsterModelContainer<T: Decodable>: Decodable {
	let data: [T]
}

struct MonsterModel: Equatable {
	
	private struct Attributes: Decodable {
		let identity: String
		let name: String
		let description: String
		let despair: Int
		let slogan: String
		
		enum CodingKeys: String, CodingKey {
			case identity, name, description, despair, slogan
		}
	}
	
	let id: Int
	let imageURLString: String
	let name: String
	let score: Int
	let description: String
	let tagline: String
}

extension MonsterModel: Codable {
	
	enum CodingKeys: String, CodingKey {
		case id, name, score, attributes, imageURLString, description, tagline
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let stringId = try container.decode(String.self, forKey: .id)
		id = Int(stringId) ?? 0
		let attributes = try container.decode(Attributes.self, forKey: .attributes)
		imageURLString = attributes.identity
		name = attributes.name
		score = attributes.despair
		description = attributes.description
		tagline = attributes.slogan
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(imageURLString, forKey: .imageURLString)
		try container.encode(name, forKey: .name)
		try container.encode(score, forKey: .score)
		try container.encode(description, forKey: .description)
		try container.encode(tagline, forKey: .tagline)
	}
}

extension MonsterModel: CardPresentable {
	
	var placeholderImage: UIImage? { return UIImage.monsterPlaceholder }
	var nameText: String { return name }
	var dialLabel: String { return "" }
	var detailText: String { return tagline }
	var action: CardAction? { return CardAction(title: String(.callMonster)) }
}
