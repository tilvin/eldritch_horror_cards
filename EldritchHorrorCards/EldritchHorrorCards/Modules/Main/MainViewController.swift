//
//  MainViewController.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
	
	//MARK: - Init
	
	override func viewDidLoad() {
		super.viewDidLoad()
		isHiddenNavigationBar = true
		let controller = MonstersViewController()
		controller.monsterDelegate = self
		view.embed(subview: controller.view)
		addChildViewController(controller)
		controller.didMove(toParentViewController: self)
	}
}

extension MainViewController: MonstersViewControllerDelegate {
	
	func call(monster: Monster) {
		let provider = DI.providers.resolve(MonsterDataProviderProtocol.self)!
		let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
		let ancient = monster.id
		
		provider.selectAncient(gameId: gameProvider.game.id, ancient: ancient) { [weak self] (success) in
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
