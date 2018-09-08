//
//  KeybordViewHelper.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 8/31/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension UIView {
	var globalPoint: CGPoint? {
		return self.superview?.convert(self.frame.origin, to: nil)
	}
	
	var globalFrame: CGRect? {
		return self.superview?.convert(self.frame, to: nil)
	}	
}
