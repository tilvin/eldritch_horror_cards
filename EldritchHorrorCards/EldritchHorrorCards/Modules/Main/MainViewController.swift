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
		let vc = CardViewController.controllerFromStoryboard(.main)
		vc.modalTransitionStyle = .crossDissolve
		appNavigator?.go(controller: vc, mode: .modal)
	}
	
	func showDetail(monster: Monster) {
		let controller = MonsterDetailViewController.controllerFromStoryboard(.main)
		controller.monster = monster
		appNavigator?.go(controller: controller, mode: .push)
	}
}
