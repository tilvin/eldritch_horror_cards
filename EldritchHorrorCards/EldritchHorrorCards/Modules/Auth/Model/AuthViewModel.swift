//
//  AuthViewModel.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 10/20/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import Foundation

enum AuthTextViewType: Int {
	case email, password
}

struct AuthViewModel {
	private var items: [AuthTextViewType: AuthTextViewModel] = [:]
	
	mutating func item(type: AuthTextViewType) -> AuthTextViewModel {
		guard let item = items[type] else {
			var model: AuthTextViewModel!
			switch type {
			case .email:
				model = AuthTextViewModel(type: .email, state: .active)
			case .password:
				model = AuthTextViewModel(type: .password)
			}
			self.items[type] = model
			return model
		}
		return item
	}
	
	init() {
		items[.email] = AuthTextViewModel(type: .email, state: .active)
		items[.password] = AuthTextViewModel(type: .password)
	}
	
	public mutating func update(itemType: AuthTextViewType, value: String, state: AuthTextViewState) {
		items[itemType] = AuthTextViewModel(type: itemType, text: value, state: state)
	}
}
