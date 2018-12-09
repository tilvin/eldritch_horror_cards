//
//  SimpleCard.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/25/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

public struct Cards: Codable {
	public let avaliableCardTypes: [String]
	
	enum CodingKeys: String, CodingKey {
		case avaliableCardTypes = "avaliable_card_types"
	}
	
}
