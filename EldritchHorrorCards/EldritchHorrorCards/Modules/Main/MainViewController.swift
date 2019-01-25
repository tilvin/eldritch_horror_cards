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
	
	func call(monster: Monster) {
		let provider = DI.providers.resolve(MonsterDataProviderProtocol.self)!
		let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
		
		provider.selectAncient(gameId: gameProvider.game.id, ancient: monster) { [weak self] (success) in
			guard let sSelf = self else { return }
			if success {
				let controller = CardsViewController()
				controller.modalTransitionStyle = .crossDissolve
				sSelf.appNavigator?.go(controller: controller, mode: .modal)
			}
			else {
				sSelf.showErrorAlert(message: String(.loadMonsterError))
			}
		}
	}
	
	func showDetail(monster: Monster) {
		let controller = MonsterDetailViewController.controllerFromStoryboard(.main)
		controller.monster = monster
		appNavigator?.go(controller: controller, mode: .push)
	}
}
