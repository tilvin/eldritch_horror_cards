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
		
		//TODO: добавить TapGesture по главной вьюхе (которая self.view)
		// по нажатию вызывать backgroundTap()
    }
	
	//MARK: - Private
	
	@objc private func backgroundTap() {
		close()
	}
}
