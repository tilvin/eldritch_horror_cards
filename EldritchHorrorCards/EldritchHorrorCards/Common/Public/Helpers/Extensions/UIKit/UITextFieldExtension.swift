//
//  UITextFieldExtension.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 9/9/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension UITextField {
	
	convenience init(placeholder: String, textColor: UIColor) {
		self.init()
		self.placeholder = placeholder
		self.textColor = textColor
	}
}
