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
	
	//MARK: - Lifecycle
	
	init() {
		super.init(nibName: nil, bundle: nil)
		isHiddenBackButton = true
		isHiddenNavigationBar = true
		hidesBottomBarWhenPushed = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = LocalStoryView(frame: UIScreen.main.bounds)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
