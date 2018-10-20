//
//  File.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 10/20/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct AuthTextViewModel {
	let placeholder: String
	let text: String
	let type: AuthTextViewType
	let image: UIImage
	let isSecureTextField: Bool
	let state: AuthTextViewState
	
	init(type: AuthTextViewType, text: String = "", state: AuthTextViewState = .normal) {
		self.text = text
		self.type = type
		self.state = state
		
		switch type {
		case .email:
			placeholder = String(.email)
			image = .email
			isSecureTextField = false
		case .password:
			placeholder = String(.password)
			image = .password
			isSecureTextField = true
		}
	}
}
