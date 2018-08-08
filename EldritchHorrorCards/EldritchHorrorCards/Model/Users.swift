//
//  Users.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 02.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct User: Codable {
	let token: String
	let login: String
	let password: String
	let userName: String
	let imageURL: String
	
	enum CodingKeys: String, CodingKey {
		case token = "token"
		case login = "login"
		case password = "password"
		case userName = "user_name"
		case imageURL = "image_url"
	}
	
	public init(token: String, login: String, password: String, userName: String, imageURL: String) {
		self.token = token
		self.login = login
		self.password = password
		self.userName = userName
		self.imageURL = imageURL
	}
}
