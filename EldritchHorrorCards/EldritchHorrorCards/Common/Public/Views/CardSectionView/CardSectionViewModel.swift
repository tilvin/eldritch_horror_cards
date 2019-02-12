//
//  SectionViewModel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 19/11/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct CardSectionViewModel {
	let text: String
	let backgroundColor: UIColor
	let textColor: UIColor
	let isSelectable: Bool
	
	init(text: String, backgroundColor: UIColor, textColor: UIColor) {
		self.text = text
		self.backgroundColor = backgroundColor
		self.textColor = textColor
		isSelectable = false
	}
	
	init() {
		text = ""
		backgroundColor = .white
		textColor = .mako
		isSelectable = false
	}
}
