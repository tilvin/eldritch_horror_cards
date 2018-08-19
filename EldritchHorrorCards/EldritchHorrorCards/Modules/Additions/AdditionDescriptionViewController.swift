//
//  AdditionDescriptionViewController.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 8/18/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class AdditionDescriptionViewController: BaseViewController {

	@IBOutlet private var descriptionTextView: UITextView!
	
	var additionDescription: String = ""
	
	override func viewDidLoad() {
        super.viewDidLoad()
		descriptionTextView.text = additionDescription
		let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
		view.addGestureRecognizer(tap)
    }
	
	//MARK: - Private
	
	@objc private func backgroundTap() {
		let controller = AdditionsViewController.controllerFromStoryboard(.additions)
		controller.modalTransitionStyle = .crossDissolve
		appNavigator?.go(controller: controller, mode: .modal)
	}
}
