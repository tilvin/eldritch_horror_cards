//
//  LocalStoryViewController.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/24/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class LocalStoryViewController: BaseViewController {
	
	private var customView: LocalStoryView { return view as! LocalStoryView }
	
	private let model: LocalStoryModel
	
	//MARK: - Lifecycle
	
	init(model: LocalStoryModel) {
		self.model = model
		super.init(nibName: nil, bundle: nil)
		isHiddenBackButton = true
		isHiddenNavigationBar = true
		hidesBottomBarWhenPushed = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = LocalStoryView(frame: UIScreen.main.bounds, viewModel: LocalStoryViewModel(model: model))
		customView.delegate = self
	}
}

extension LocalStoryViewController: LocalStoryViewDelegate {
	
	func backButtonPressed() {
		dismiss(animated: true, completion: nil)
	}
}
