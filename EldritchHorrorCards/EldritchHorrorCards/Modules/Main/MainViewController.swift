//
//  MainViewController.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

// NOT implemented yet
extension MainViewController {
    
    struct Appearance {
        let searchButtonHeight: CGFloat = 10
        let searchButtonLeftOffset: CGFloat = 10
        let searchButtonBottomOffset: CGFloat = 10
    }
}
class MainViewController: BaseViewController {
    
    let appearance = Appearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		isHiddenNavigationBar = true
		let controller = MonstersViewController.controllerFromStoryboard(.main)
		controller.monsterDelegate = self
		view.embed(subview: controller.view)
		addChildViewController(controller)
		controller.didMove(toParentViewController: self)
	}
    
    // NOT on view
    lazy var searchButton: CustomButton = {
        let button = CustomButton(type: .darkGreenBlue)
        button.setImage(UIImage.info, for: .normal)     // info image while search image is not add
        return button
    }()
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
