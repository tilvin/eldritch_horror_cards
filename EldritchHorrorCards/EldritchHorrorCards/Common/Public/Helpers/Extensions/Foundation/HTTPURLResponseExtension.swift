//
//  HTTPURLResponseExtension.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 10/6/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
	
	enum StatusCodeType {
		case ok
		case other
	}
	
	var status: StatusCodeType {
		return self.statusCode == 200 ? .ok : .other
	}
}
