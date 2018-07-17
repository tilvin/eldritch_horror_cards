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
    var subtitle: String
    var cultist: String
    var prepeare: String
    var myth_stack: String
    var description_info: [String]
    var other: String
    var imageURLString: String
	var score: Int
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
//        return detail
        return subtitle
	}
	
	var action: CardAction? {
		return CardAction(title: "call_monster".localized)
	}
}
