//
//  Moster.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/16/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

final class Monster: Object, Mappable {
	@objc dynamic var uid: String = ""
	@objc dynamic var id: Int = 0
	@objc dynamic var imageURLString: String = ""
	@objc dynamic var name: String = ""
	@objc dynamic var score: Int = 0
	@objc dynamic var desc: String = ""
	@objc dynamic var slogan: String = ""

	required convenience init?(map: Map) {
		self.init()
	}
	
	override class func primaryKey() -> String? {
		return "uid"
	}
	
	func mapping(map: Map) {
		self.id <- map["id"]
		self.imageURLString <- map["identity"]
		self.name <- map["name"]
		self.score <- map["score"]
		self.desc <- map["description"]
		self.slogan <- map["slogan"]
		self.uid = "\(id)"
	}
}

extension Monster: CardPresentable {
	
	var placeholderImage: UIImage? {
		return UIImage(named: "placeholder_image")!
	}
	
	var nameText: String {
		return name
	}
	
	var dialLabel: String {
		guard let char = nameText.first else { return "" }
		return String(char).capitalized
	}
	
	var detailText: String {
		return slogan
	}
	
	var action: CardAction? {
		return CardAction(title: String(.callMonster))
	}
}
