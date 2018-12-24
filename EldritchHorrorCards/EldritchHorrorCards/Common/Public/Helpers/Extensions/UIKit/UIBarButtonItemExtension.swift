//
//  UIBarButtonItemExtension.swift
//  Ebs
//
//  Created by Vadim on 28/09/2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
	
	private struct Appearance {
		let backButtonTopOffset: CGFloat = ScreenType.item(for: (.inch4, -1), (.inch5_5, 6), (.inch5_8, -1))
		let backButtonLeftOffset: CGFloat = ScreenType.item(for: (.inch4, 2), (.inch5_5, 0), (.inch5_8, -3))
	}
	
	public static func backButton(target: Any?, action: Selector?) -> UIBarButtonItem {
		let backButton = UIBarButtonItem(image: UIImage.backButton.withRenderingMode(.alwaysOriginal),
										 style: .plain,
										 target: target,
										 action: action)
		let appearance = Appearance()
		let insets = UIEdgeInsets(top: appearance.backButtonTopOffset,
								  left: appearance.backButtonLeftOffset,
								  bottom: -appearance.backButtonTopOffset,
								  right: appearance.backButtonLeftOffset)
		backButton.imageInsets = insets
		return backButton
	}
	
}
