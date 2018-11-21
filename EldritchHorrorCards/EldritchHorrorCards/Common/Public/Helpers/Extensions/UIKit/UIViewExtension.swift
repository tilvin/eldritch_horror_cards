//
// Created by Andrey Torlopov on 9/4/18.
// Copyright (c) 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

extension UIView {
	
	public func showProccessing() {
		DispatchQueue.main.async {
			if let window = UIApplication.shared.keyWindow {
				window.addSubview(LoaderView(frame: window.frame))
			}
		}
	}
	
	public func hideProccessing() {
		DispatchQueue.main.async {
			if let window = UIApplication.shared.keyWindow {
				window.subviews.forEach { view in
					if view is LoaderView { view.removeFromSuperview() }
				}
			}
		}
	}
	
	public func showInternetStatus(isConnected: Bool) {
		DispatchQueue.main.async {
			if let window = UIApplication.shared.keyWindow {
				let frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 20)
				let type: InternetStatusType = isConnected ? .online : .offline
				let view = InternetStatusView(frame: frame, type: type)
				window.addSubview(view)
				UIView.animate(withDuration: isConnected ? 0 : 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
					view.frame.origin.y += 20
				}, completion: nil)
			}
		}
	}
	
	public func hideInternetStatus() {
		DispatchQueue.main.async {
			if let window = UIApplication.shared.keyWindow {
				window.subviews.forEach { view in
					if view is InternetStatusView {
						UIView.animate(withDuration: 0.25, animations: {
							view.frame.origin.y = 0
						}, completion: { (_) in
							view.removeFromSuperview()
						})
						
					}
				}
			}
		}
	}
	
	convenience init(backgroundColor: UIColor) {
		self.init()
		self.backgroundColor = backgroundColor
	}
}
