//
// Created by Andrey Torlopov on 9/4/18.
// Copyright (c) 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

extension UIView {
	
	func showProccessing() {
		DispatchQueue.main.async {
			if let window = UIApplication.shared.keyWindow {
				window.addSubview(LoaderView(frame: window.frame))
			}
		}
	}
	
	func hideProccessing() {
		DispatchQueue.main.async {
			if let window = UIApplication.shared.keyWindow {
				window.subviews.forEach { view in
					if view is LoaderView { view.removeFromSuperview() }
				}
			}
		}
	}
}
