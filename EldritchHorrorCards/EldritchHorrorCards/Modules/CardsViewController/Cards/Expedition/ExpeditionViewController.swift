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
	let provider = DI.providers.resolve(ExpeditionDataProviderProtocol.self)!
	
	//MARK: - Private variables
	
	private var expeditions: [Expedition] = []
	
	// MARK: - View lifecycle
	
	override func loadView() {
		let view = ExpeditionView(frame: UIScreen.main.bounds, viewModel: ExpeditionViewModel())
		isHiddenNavigationBar = true
		self.view = view
		view.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let expedition = provider.expedition, let type = provider.expeditionType else { return }
		customView.update(viewModel: ExpeditionViewModel(with: expedition, type: type))		
	}
}

extension ExpeditionViewController: ExpeditionViewDelegate {
	
	func backButtonTap() {
		close()
	}
}
