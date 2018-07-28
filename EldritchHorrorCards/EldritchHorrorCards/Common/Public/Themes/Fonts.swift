//
//  Fonts.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension UIFont {
	
	private enum FontNames: String {
		case light = "AppleSDGothicNeo-Light"
		case regular = "AppleSDGothicNeo-Regular"
		case bold = "AppleSDGothicNeo-Bold"
	}
	
	//MARK: Bold
	
	class var bold28: UIFont {
		return UIFont.bold(of: 28)
	}
	//MARK: Regular
	
	class var regular14: UIFont {
		return UIFont.regular(of: 14)
	}
	
	//MARK: Light
	
	class var light15: UIFont {
		return UIFont.light(of: 15)
	}
	
	//MARK: - Private
	
	private class func bold(of size: CGFloat) -> UIFont {
		return UIFont(name: FontNames.bold.rawValue, size: size)!
	}
	
	private class func regular(of size: CGFloat) -> UIFont {
		return UIFont(name: FontNames.regular.rawValue, size: size)!
	}
	
	private class func light(of size: CGFloat) -> UIFont {
		return UIFont(name: FontNames.light.rawValue, size: size)!
	}
}
