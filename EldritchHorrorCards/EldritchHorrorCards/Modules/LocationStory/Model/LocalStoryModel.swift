//
//  File.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/24/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct LocalStoryModel: Codable {
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
