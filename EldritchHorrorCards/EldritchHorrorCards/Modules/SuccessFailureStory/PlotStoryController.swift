//
//  ExpeditionViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import UIKit

class PlotStoryController: BaseViewController {
	public var customView: PlotStoryView { return self.view as! PlotStoryView }
	private let provider = DI.providers.resolve(ExpeditionDataProviderProtocol.self)!
	
	// MARK: - View lifecycle

	override func loadView() {
		isHiddenNavigationBar = true
		view = PlotStoryView(frame: UIScreen.main.bounds, viewModel: PlotStoryViewModel())
		customView.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard let expedition = provider.expedition, let type = provider.expeditionType else { return }
		customView.update(viewModel: PlotStoryViewModel(with: expedition, type: type))		
	}
}

extension PlotStoryController: ExpeditionViewDelegate {
	
	func backButtonTap() {
		close()
	}
}
