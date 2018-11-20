//
//  MultipartDataItem.swift
//  Ebs
//
//  Created by Vitalii Poponov on 16.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import Foundation

struct MultipartDataItem {
	let data: Data
	let name: String
	let fileName: String?
	let mimeType: String?
}
