//
//  MainViewController.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

typealias ShowErrorHandler = (String) -> ()

class MainViewController: BaseViewController {
	
	//MARK: - Private variables
	
    private var showErrorHandler: ShowErrorHandler?
	
	//MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		isHiddenNavigationBar = true
		let controller = MonstersViewController()
		controller.monsterDelegate = self
        controller.showMessageHandler = showErrorHandler
		view.embed(subview: controller.view)
		addChildViewController(controller)
		controller.didMove(toParentViewController: self)
        showErrorHandler = { [weak self] (message) in
            self?.showErrorAlert(message: message)
        }
	}
}

extension MainViewController: MonstersViewControllerDelegate {
	
	func call(monster: MonsterModel) {
		let provider = DI.providers.resolve(MonsterDataProviderProtocol.self)!
		let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
		
		gameProvider.setSelectedAncient(ancient: monster)
		provider.selectAncient(gameId: gameProvider.game.id, ancient: monster) { [weak self] (result) in
			guard let sSelf = self else { return }
			switch result {
			case .success:
				let controller = CardsViewController()
				controller.modalTransitionStyle = .crossDissolve
				sSelf.appNavigator?.go(controller: controller, mode: .modal)
			case .failure(let error):
				sSelf.showErrorAlert(message: error.message)
			}
		}
	}
	
	func showDetail(monster: MonsterModel) {
		let controller = MonsterDetailViewController.controllerFromStoryboard(.main)
		controller.monster = monster
		appNavigator?.go(controller: controller, mode: .push)
	}
}
