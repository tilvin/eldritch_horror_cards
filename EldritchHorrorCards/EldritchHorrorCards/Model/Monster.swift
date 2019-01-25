//
//  Moster.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import Foundation

struct Monster: Codable {
	public let id: Int
	public let imageURLString: String
	public let name: String
	public let score: Int
	public let description: String
	public let slogan: String
	
	enum CodingKeys: String, CodingKey {
		case id = "id"
		case imageURLString = "identity"
		case name = "name"
		case score = "despair"
		case description = "description"
		case slogan = "slogan"
	}
}

extension Monster: CardPresentable {
	
	var placeholderImage: UIImage? {
		return UIImage(named: "placeholder_image")!
	}
	
	var nameText: String {
		return name
	}
	
	var dialLabel: String {
		guard let char = nameText.first else { return "" }
		return String(char).capitalized
	}
	
	var detailText: String {
		return slogan
	}
	
	var action: CardAction? {
		return CardAction(title: String(.callMonster))
	}
}
