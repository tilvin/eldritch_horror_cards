//
//  ExpeditionViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import UIKit

class PlotStoryController: BaseViewController {
	
	private var customView: PlotStoryView { return self.view as! PlotStoryView }
	
	// MARK: - Lifecycle

	override func loadView() {
		isHiddenNavigationBar = true
		view = PlotStoryView(frame: UIScreen.main.bounds, viewModel: PlotStoryViewModel())
		customView.delegate = self
	}
}

extension PlotStoryController: ExpeditionViewDelegate {
	
	func backButtonTap() {
		close()
	}
}
