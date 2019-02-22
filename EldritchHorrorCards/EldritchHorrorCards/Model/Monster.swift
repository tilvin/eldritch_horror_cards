//
//  Moster.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct Monster: Codable {
	var id: Int = 0
	var imageURLString: String = ""
	var name: String = ""
	var score: Int = 0
	var desc: String = ""
	var tagline: String = ""
	
//	enum CodingKeys: String, CodingKey {
//		case id = ""
//		case imageURLString = ""
//		case name = ""
//		case score = ""
//		case desc = ""
//		case tagline = ""
//	}
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//
//		if let value = try? values.decode(String.self, forKey: .token) {
//			self.token = value
//		}
//		
//	}
//
//	func encode(to encoder: Encoder) throws {
//		var container = encoder.container(keyedBy: CodingKeys.self)
//		try container.encode(token, forKey: .token)
//		try container.encode(login, forKey: .login)
//		try container.encode(userName, forKey: .userName)
//		try container.encode(imageURL, forKey: .imageURL)
//	}
}

extension Monster: CardPresentable {
	
	var placeholderImage: UIImage? { return UIImage(named: "placeholder_image")! }
	var nameText: String { return name }
	var dialLabel: String { return "" }
	var detailText: String { return tagline }
	var action: CardAction? { return CardAction(title: String(.callMonster)) }
}
