//
//  PlotStoryModel.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/24/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct PlotStoryModel: Codable {
	let initialEffect: String
	let passEffect: String
	let failEffect: String
	
	enum CodingKeys: String, CodingKey {
		case initialEffect = "initial_effect"
		case passEffect = "pass_effect"
		case failEffect = "fail_effect"
	}
}
