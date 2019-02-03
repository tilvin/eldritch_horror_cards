//
//  Realm.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 2/3/19.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation
import RealmSwift

public func refreshRealm() {
	let realm = try! Realm()
	guard !realm.isInWriteTransaction else {
		delay(seconds: 0.1) { refreshRealm() }
		return
	}
	realm.beginWrite()
	try! realm.commitWrite()
}
