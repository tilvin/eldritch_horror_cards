//
//  ExpeditionViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import UIKit

class ExpeditionViewController: BaseViewController {
	
	//MARK: - Public variables
	
	var customView: ExpeditionView { return self.view as! ExpeditionView }
	
	//MARK: - Private variables
	
	private var cardsDataProvider = DI.providers.resolve(CardDataProviderProtocol.self)!
	private var expeditions: [StoryCard] = []
	
	// MARK: - View lifecycle
	
	override func loadView() {
		view = ExpeditionView(frame: UIScreen.main.bounds, viewModel: ExpeditionViewModel())
		isHiddenNavigationBar = true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cardsDataProvider.load(gameId: 34) { [weak self] (success) in
			//guard let sSelf = self,
				//success,
				//let expedition = sSelf.cardsDataProvider.expeditions.first else { return }
			//sSelf.customView.update(viewModel: ExpeditionViewModel(with: expedition))
		}
		
	}
}

