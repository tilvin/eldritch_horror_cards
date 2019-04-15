//
//  ModelContainer.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 15/04/2019.
//  Copyright © 2019 Andrey Torlopov. All rights reserved.
//

import Foundation

struct ModelContainer<T: Decodable>: Decodable {
	let data: [T]
}
