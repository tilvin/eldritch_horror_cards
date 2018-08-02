//
//  Users.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 02.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct User: Codable {
	let login: String
	let password: String
	let userName: String
	let imageURL: String
	
	enum CodingKeys: String, CodingKey {
		case login = "login"
		case password = "password"
		case userName = "userName"
		case imageURL = "imageURL"
	}
	
	public init(login: String, password: String, userName: String, imageURL: String) {
		self.login = login
		self.password = password
		self.userName = userName
		self.imageURL = imageURL
	}
}
