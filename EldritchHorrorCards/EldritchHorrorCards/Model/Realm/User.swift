//
//  User.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 02.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

protocol UserProtocol: class {
	var token: String { get set }
	var login: String { get set }
	var userName: String { get set }
	var imageURL: String { get set }
	
	var image: UIImage? { get set }
}

class User: Object, Mappable {
	@objc dynamic var token: String = ""
	@objc dynamic var login: String = ""
	@objc dynamic var userName: String = ""
	@objc dynamic var imageURL: String = ""
	
	//TODO: дописать метод, который из папки с документами по логику пользователя будет извлекать картинку.
	var image: UIImage?
	
	required convenience init?(map: Map) {
		self.init()
	}
	
	override class func primaryKey() -> String? {
		return "userName"
	}
	
	func mapping(map: Map) {
		self.token <- map["token"]
		self.login <- map["login"]
		self.userName <- map["user_name"]
		self.imageURL <- map["image_url"]
	}
}

extension User: UserProtocol {}
