//
//  Colors.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension UIColor {
	
	static var wildSand: UIColor {
		return UIColor(hexString: "F5F5F5")
	}
	
	static var scorpion: UIColor {
		return UIColor(hexString: "5F5F5F")
	}
	
	static var mineShaft: UIColor {
		return UIColor(hexString: "3B3B3B")
	}

	//MARK: - Inits
	
	convenience init(components red: CGFloat, green: CGFloat, blue: CGFloat) {
		let const: CGFloat = 255.0
		self.init(red: red/const, green: green/const, blue: blue/const, alpha: 1)
	}
	
	convenience init(components red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		let const: CGFloat = 255.0
		self.init(red: red/const, green: green/const, blue: blue/const, alpha: alpha/const)
	}
}
