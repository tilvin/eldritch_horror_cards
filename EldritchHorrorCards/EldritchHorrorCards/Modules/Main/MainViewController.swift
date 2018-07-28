//
//  MainViewController.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		self.isHiddenNavigationBar = true
		
		let controller = MonstersViewController.controllerFromStoryboard(.main)
		controller.monsterDelegate = self
		view.embed(subview: controller.view)
		addChildViewController(controller)
		controller.didMove(toParentViewController: self)
	}
}

extension MainViewController: MonstersViewControllerDelegate {

	func call(monster: Monster) {
		print("call monster \(monster)")
	}
	
	func showDetail(monster: Monster) {
		let controller = MonsterDetailViewController.controllerFromStoryboard(.main)
		controller.monster = monster
		appNavigator?.go(controller: controller, mode: .push)
	}
}
