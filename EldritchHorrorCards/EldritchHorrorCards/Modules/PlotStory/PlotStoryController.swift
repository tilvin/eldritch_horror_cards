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
	private let model: PlotStoryModel
	private let type: String
	
	//MARK: - Lifecycle
	
	init(model: PlotStoryModel, type: String) {
		self.model = model
		self.type = type
		super.init(nibName: nil, bundle: nil)
		isHiddenBackButton = true
		isHiddenNavigationBar = true
		hidesBottomBarWhenPushed = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		isHiddenNavigationBar = true
		view = PlotStoryView(frame: UIScreen.main.bounds, viewModel: PlotStoryViewModel(with: model, type: type))
		customView.delegate = self
	}
}

extension PlotStoryController: ExpeditionViewDelegate {
	
	func closeButtonPressed() {
		close()
	}
}
