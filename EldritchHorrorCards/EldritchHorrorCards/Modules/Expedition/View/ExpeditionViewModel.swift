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
    let successViewModel: SectionViewModel
    let failureViewModel: SectionViewModel
	
	//MARK: - Init
	
	init(with model: Expedition? = nil, type: String? = nil) {
		if let model = model, let type = type {
			self.title = type.localized
			self.image = UIImage(named: type)!
			self.story = model.initialEffect ?? ""
            successViewModel = SectionViewModel(text: model.passEffect ?? "", backgroundColor: .gallery, textColor: .mako)
            failureViewModel = SectionViewModel(text: model.failEffect ?? "", backgroundColor: .paleSalmon, textColor: .mako)
		}
		else {
			title = ""
			image = nil
			story = ""
            successViewModel = SectionViewModel(text: "", backgroundColor: .gallery, textColor: .mako)
            failureViewModel = SectionViewModel(text: "", backgroundColor: .paleSalmon, textColor: .mako)
		}
	}
}
