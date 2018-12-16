//
//  ExpeditionViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import UIKit

class ExpeditionViewController: BaseViewController {
	public var customView: ExpeditionView { return self.view as! ExpeditionView }
	private let provider = DI.providers.resolve(ExpeditionDataProviderProtocol.self)!
	
	// MARK: - View lifecycle

	override func loadView() {
		isHiddenNavigationBar = true
		view = ExpeditionView(frame: UIScreen.main.bounds, viewModel: ExpeditionViewModel())
		customView.delegate = self
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
