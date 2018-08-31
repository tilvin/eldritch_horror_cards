//
//  Keyboardable.swift
//  ObserveKeyboardNotifications
//
//  Created by Andrey Torlopov on 8/31/18.
//  Copyright © 2018 ShengHua Wu. All rights reserved.
//

import UIKit

protocol Keyboardable: class {
	var editableViews: [UIResponder] { get }
	var notificationTokens: [NotificationToken] { get set }
}

extension Keyboardable where Self: UIViewController {
	
	func registerKeyboardNotifications() {
		self.editableViews.forEach { [unowned self] (responder) in
			self.register(responder: responder)
		}
	}
	
	private func register(responder: UIResponder) {
		guard let responderView = responder as? UIView else { return }
		let center = NotificationCenter.default
		
		let keyboardWillShowToken = center.addObserver(with: UIViewController.keyboardWillShow) { [unowned self] (payload) in
			let responderViewFrame = responderView.globalFrame ?? responderView.frame
			let isNeedOffset = payload.endFrame.height >= self.view.frame.height - responderViewFrame.minY
			let offsetValue = payload.endFrame.height + 50 - self.view.frame.height + responderViewFrame.minY
			if isNeedOffset {
				UIView.animate(withDuration: payload.duration, animations: {
					self.view.frame.origin.y -= offsetValue
				})
			}
		}
		self.notificationTokens.append(keyboardWillShowToken)
		
		let keyboardWillHideToken = center.addObserver(with: UIViewController.keyboardWillHide) { (payload) in
			UIView.animate(withDuration: payload.duration, animations: {
				self.view.frame.origin.y = 0
			})
		}
		
		self.notificationTokens.append(keyboardWillHideToken)
	}
	
	func unregisterKeyboardNotifications() {
		self.notificationTokens.removeAll()
	}
}
 
