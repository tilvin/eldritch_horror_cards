//
//  Game.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 25/09/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

protocol GameProtocol: class {
	var id: Int { get set }
	var token: String { get set }
	var expeditionLocation: String { get set }
	var isSessionActive: Bool { get }
}

final class Game: Object, Mappable {
	@objc dynamic var uid: String = UUID().uuidString
	@objc dynamic var id: Int = 0
	@objc dynamic var token: String = ""
	@objc dynamic var expeditionLocation: String = ""
	@objc dynamic var expireDate: Date = Date().adjust(.day, offset: 2)
	
	var isSessionActive: Bool {
		return Date() > expireDate || token.isEmpty
	}
	
	//MARK: - Init
	
	required convenience init?(map: Map) {
		self.init()
	}
	
	override class func primaryKey() -> String? {
		return "uid"
	}
	
	func mapping(map: Map) {
		self.id <- map["id"]
		self.token <- map["token"]
		self.expeditionLocation <- map["expedition_location"]
	}
}

extension Game: GameProtocol {}
