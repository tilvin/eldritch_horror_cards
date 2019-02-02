//
//  UIScreenExtension.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import UIKit

public enum ScreenType: CGFloat {
	case inch4 = 568 //iPhone 5, 5c, 5s, iPod 5
	case inch4_7 = 667//iPhone 6, 6s, 7, 8
	case inch5_5 = 736//iPhone 6+, 6s+, 7+, 8+
	case inch5_8 = 812 //iPhone X
	case inch6_1 = 896 //iPhone XR, XS
	case inch9_7 = 1024 //iPad mini & iPad Air & iPad Pro
	case inch10_5 = 1112//iPad Pro
	case inch12_9 = 1366//iPad Pro
	case other
	
	static func item<T>(for deviceSizes: (size: ScreenType, item: T)...) -> T {
		let currentSize = UIScreen.main.screenType.rawValue
		
		if let item = (deviceSizes.sorted { $0.size.rawValue > $1.size.rawValue }.filter { $0.size.rawValue <= currentSize }).first?.item {
			return item
		}
		return deviceSizes.enumerated().min( by: { abs($0.1.size.rawValue - currentSize) < abs($1.1.size.rawValue - currentSize) })!.element.item
	}
}

extension UIScreen {
	var screenType: ScreenType {
		let maxLenght: CGFloat = max(self.bounds.width, self.bounds.height)
		return ScreenType(rawValue: maxLenght) ?? .other
	}
}
