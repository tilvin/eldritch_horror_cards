//
//  ExpeditionViewModel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct ExpeditionViewModel {
	let title: String
	let story: String
	let success: String
	let failure: String
	
	//MARK: - Init
	
	init(with model: StoryCard? = nil) {
		if let model = model {
			self.title = model.title
			self.story = model.story
			self.success = model.success
			self.failure = model.failure
		}
		else {
			self.title = ""
			self.story = ""
			self.success = ""
			self.failure = ""
		}
	}
}
