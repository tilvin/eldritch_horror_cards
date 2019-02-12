//
//  NetworkErrorModel.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/24/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

struct NetworkErrorModel {
	let message: String
	
	init(error: Error?) {
		guard let error = error else {
			message = String(.unknownError)
			return
		}
		message = "\(String(.errorMessageTemplate))\n\(error.localizedDescription)"
	}
	
	init(message: String) {
		self.message = message
	}
}
