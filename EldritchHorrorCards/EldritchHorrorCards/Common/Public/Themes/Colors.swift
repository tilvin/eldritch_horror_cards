//
//  Colors.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension UIColor {
	
	static var wildSand: UIColor { return UIColor(hexString: "F5F5F5") }
	static var scorpion: UIColor { return UIColor(hexString: "5F5F5F") }
	static var mineShaft: UIColor { return UIColor(hexString: "3B3B3B") }
	static var elm: UIColor { return UIColor(hexString: "1F746E") }
	static var darkGreenBlue: UIColor { return UIColor(components: 31, green: 116, blue: 110) }
	static var darkGreenBlueLight: UIColor { return UIColor(components: 35, green: 128, blue: 100) }
	static var gallery: UIColor { return UIColor(hexString: "EBEBEB") }
	static var alto: UIColor { return UIColor(hexString: "D8D8D8") }
	static var mako: UIColor { return UIColor(hexString: "3D434A") }
	static var viridian: UIColor { return UIColor(hexString: "1F746E") }
	static var viridianTwo: UIColor { return UIColor(hexString: "228079") }
	static var errorBorder: UIColor { return UIColor(hexString: "D34747") }
	static var paleSalmon: UIColor { return UIColor(hexString: "FEB4B2") }
	static var whiteTwo: UIColor { return UIColor(hexString: "FFFFFF") }
	static var shadowGreen: UIColor { return UIColor(hexString: "9DC3C1") }
	static var pigeonPost: UIColor { return UIColor(hexString: "A5C6DB") }
	
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
