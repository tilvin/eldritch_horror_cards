//
//  ExpeditionViewModel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct PlotStoryViewModel {
	let title: String
	let image: UIImage?
	let story: String
	let successViewModel: CardSectionViewModel
	let failureViewModel: CardSectionViewModel
	
	//MARK: - Init
	
	init(with model: PlotStoryModel, type: String ) {
		title = type.localized
		image = UIImage(named: type)!
		story = model.initialEffect
		successViewModel = CardSectionViewModel(text: model.passEffect, backgroundColor: .gallery, textColor: .mako)
		failureViewModel = CardSectionViewModel(text: model.failEffect, backgroundColor: .paleSalmon, textColor: .mako)
	}
}
