//
//  SectionViewModel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 19/11/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct SectionViewModel {
	let  text: String
	let color: UIColor
	
	init(text: String, color: UIColor) {
		self.text = text
		self.color = color
	}
}
