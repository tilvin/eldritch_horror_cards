//
//  MultipartDataItem.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import Foundation

struct MultipartDataItem {
	let data: Data
	let name: String
	let fileName: String?
	let mimeType: String?
}
