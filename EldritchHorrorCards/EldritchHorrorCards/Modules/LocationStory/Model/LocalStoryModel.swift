//
//  File.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/24/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct LocalStoryModel: Decodable {
	
	private struct Attributes: Decodable {
		let topTitle: String
		let topText: String
		let middleTitle: String
		let middleText: String
		let bottomTitle: String
		let bottomText: String
		
		enum CodingKeys: String, CodingKey {
			case topTitle = "top_title"
			case topText = "top_text"
			case middleTitle = "middle_title"
			case middleText = "middle_text"
			case bottomTitle = "bottom_title"
			case bottomText = "bottom_text"
		}
	}
	
	let id: String
	let topTitle: String
	let topText: String
	
	let middleTitle: String
	let middleText: String
	
	let bottomTitle: String
	let bottomText: String
	
	enum CodingKeys: String, CodingKey {
		case id, attributes, name, description, identity, hasMap
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		let attributes = try container.decode(Attributes.self, forKey: .attributes)
		topTitle = attributes.topTitle
		topText = attributes.topText
		middleTitle = attributes.middleTitle
		middleText = attributes.middleText
		bottomTitle = attributes.bottomTitle
		bottomText = attributes.bottomText
	}
}
