//
//  LocalStoryViewModel.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/24/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

struct LocalStoryViewModel {
	let topTitle: String
	let topViewModel: CardSectionViewModel
	
	let middleTitle: String
	let middleViewModel: CardSectionViewModel
	
	let bottomTitle: String
	let bottomViewModel: CardSectionViewModel
	
	init(model: LocalStoryModel) {
		topTitle = model.topTitle
		middleTitle = model.middleTitle
		bottomTitle = model.bottomTitle
		
		topViewModel = CardSectionViewModel(text: model.topText, backgroundColor: .shadowGreen, textColor: .mako)
		middleViewModel = CardSectionViewModel(text: model.middleText, backgroundColor: .gallery, textColor: .mako)
		bottomViewModel = CardSectionViewModel(text: model.bottomText, backgroundColor: .pigeonPost, textColor: .mako)
	}
}
