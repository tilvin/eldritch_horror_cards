//
//  Moster.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct Monster: Codable {
	var name: String
	var imageURLString: String
	var detail: String
	var score: Int
	
	enum CodingKeys: String, CodingKey {
		case name = "name"
		case imageURLString = "imageURLString"
		case detail = "title"
		case score = "score"
	}
	
	init(name: String, imageURLString: String, detail: String, score: Int) {
		self.name = name
		self.imageURLString = imageURLString
		self.detail = detail
		self.score = score
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		name = try values.decode(String.self, forKey: .name)
		imageURLString = try values.decode(String.self, forKey: .imageURLString)
		detail = try values.decode(String.self, forKey: .detail)
		score = try values.decode(Int.self, forKey: .score)
	}
}

extension Monster: CardPresentable {
	
	var placeholderImage: UIImage? {
		return #imageLiteral(resourceName: "placeholder_image")
	}
	
	var nameText: String {
		return name
	}
	
	var dialLabel: String {
		guard let char = nameText.first else { return "A" }
		return String(char).capitalized
	}
	
	var detailText: String {
		return detail
	}
	
	var action: CardAction? {
		return CardAction(title: "call_monster".localized)
	}
}
