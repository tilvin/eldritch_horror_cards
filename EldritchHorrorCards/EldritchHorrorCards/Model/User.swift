//
//  User.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 02.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct User: Codable {
	let token: String
	let login: String
	let userName: String
	let imageURL: String
	var image: UIImage?
	
	enum CodingKeys: String, CodingKey {
		case token = "token"
		case login = "login"
		case userName = "user_name"
		case imageURL = "image_url"
	}
}
