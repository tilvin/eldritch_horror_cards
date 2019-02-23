//
//  Moster.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct Monster: Equatable {
	var id: Int = 0
	var imageURLString: String = ""
	var name: String = ""
	var score: Int = 0
	var desc: String = ""
	var tagline: String = ""
}

extension Monster: Codable {
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case imageURLString = "identity"
		case name = "name"
		case score = "score"
		case desc = "description"
		case tagline = "slogan"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		if let value = try? values.decode(Int.self, forKey: .id) {
			self.id = value
		}
		
		if let value = try? values.decode(String.self, forKey: .imageURLString) {
			self.imageURLString = value
		}
		
		if let value = try? values.decode(String.self, forKey: .name) {
			self.name = value
		}
		
		if let value = try? values.decode(Int.self, forKey: .score) {
			self.score = value
		}
		
		if let value = try? values.decode(String.self, forKey: .desc) {
			self.desc = value
		}
		
		if let value = try? values.decode(String.self, forKey: .tagline) {
			self.tagline = value
		}
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(imageURLString, forKey: .imageURLString)
		try container.encode(name, forKey: .name)
		try container.encode(score, forKey: .score)
		try container.encode(desc, forKey: .desc)
		try container.encode(tagline, forKey: .tagline)
	}
}

extension Monster: CardPresentable {
	
	var placeholderImage: UIImage? { return UIImage(named: "placeholder_image")! }
	var nameText: String { return name }
	var dialLabel: String { return "" }
	var detailText: String { return tagline }
	var action: CardAction? { return CardAction(title: String(.callMonster)) }
}
