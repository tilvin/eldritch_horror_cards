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
	let image: UIImage?
	let story: String
	let success: String
	let failure: String
	
	//MARK: - Init
	
	init(with model: Expedition? = nil, type: String? = nil) {
		if let model = model, let type = type {
			self.title = type.localized
			self.image = UIImage(named: type)!
			self.story = model.initialEffect ?? ""
			self.success = model.passEffect ?? ""
			self.failure = model.failEffect ?? ""
		}
		else {
			self.title = ""
			self.image = nil
			self.story = ""
			self.success = ""
			self.failure = ""
		}
	}
}
