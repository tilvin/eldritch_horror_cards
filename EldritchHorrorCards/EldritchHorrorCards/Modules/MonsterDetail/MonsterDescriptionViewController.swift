//
//  MonsterDescriptionViewController.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/31/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class MonsterDescriptionViewController: BaseViewController {
	
	//MARK: - Lifecycle
	
	init() {
		super.init(nibName: nil, bundle: nil)
		self.isHiddenNavigationBar = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let view = MonsterDescriptionView(frame: UIScreen.main.bounds)
		view.delegate = self
		self.view = view
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	//MARK: -
}

extension MonsterDescriptionViewController: MonsterDescriptionViewDelegate {
	
	func closeButtonPressed() {
		close()
	}
}