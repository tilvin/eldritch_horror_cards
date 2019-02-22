//
//  User.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 02.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

protocol UserProtocol {
	var token: String { get set }
	var login: String { get set }
	var userName: String { get set }
	var imageURL: String { get set }
	var image: UIImage? { get set }
}

struct User: Codable {
	var token: String = ""
	var login: String = ""
	var userName: String = ""
	var imageURL: String = ""
	
	//TODO: дописать метод, который из папки с документами по логику пользователя будет извлекать картинку.
	var image: UIImage?
	
	enum CodingKeys: String, CodingKey {
		case token = "token"
		case login = "login"
		case userName = "user_name"
		case imageURL = "image_url"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		if let value = try? values.decode(String.self, forKey: .token) {
			self.token = value
		}
		
		if let value = try? values.decode(String.self, forKey: .login) {
			self.login = value
		}
		
		if let value = try? values.decode(String.self, forKey: .userName) {
			self.userName = value
		}
		
		if let value = try? values.decode(String.self, forKey: .imageURL) {
			self.imageURL = value
		}
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(token, forKey: .token)
		try container.encode(login, forKey: .login)
		try container.encode(userName, forKey: .userName)
		try container.encode(imageURL, forKey: .imageURL)
	}
}

extension User: UserProtocol {}
