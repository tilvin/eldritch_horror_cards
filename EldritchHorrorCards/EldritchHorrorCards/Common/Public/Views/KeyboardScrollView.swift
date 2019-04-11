//
//  KeyboardableScrollView.swift
//  Ebs
//
//  Created by Andrey Torlopov on 11/14/18.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

class KeyboardScrollView: BaseScrollView {
	
	//MARK: - Private variables
	
	private var originalContentInset: UIEdgeInsets?
	private var originalContentOffset: CGPoint?
	private var screenHeight: CGFloat { return UIScreen.main.bounds.height }
	
	//MARK: - Lifecycle
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Handlers
	
	@objc func dismissKeyboard() {
		endEditing(true)
	}
	
	@objc(keyboardWillChange:)
	private func keyboardWillChange(notification: NSNotification) {
		let beginFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
		let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
		let isKeyboardWillShow = abs(beginFrame.origin.y - screenHeight) < 0.1
		let isKeyboardWillHide = abs(endFrame.origin.y - screenHeight) < 0.1
		let keyboardAnimationDuration = (notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? TimeInterval(0)
		
		if isKeyboardWillShow {
			originalContentInset = scrollView.contentInset
			originalContentOffset = scrollView.contentOffset
			
			makeActiveTextFieldVisible(keyboardRect: endFrame, keyboardAnimationDuration: keyboardAnimationDuration)
		}
		else if isKeyboardWillHide {
			UIView.animate(withDuration: keyboardAnimationDuration, animations: {
				self.scrollView.contentInset = self.originalContentInset ?? UIEdgeInsets.zero
				self.scrollView.contentOffset = self.originalContentOffset ?? CGPoint.zero
			}, completion: nil)
		}
		else {
			makeActiveTextFieldVisible(keyboardRect: endFrame, keyboardAnimationDuration: keyboardAnimationDuration)
		}
	}
	
	//MARK: - Private
	
	private func makeActiveTextFieldVisible(keyboardRect: CGRect, keyboardAnimationDuration: TimeInterval) {
		var visibleScrollFrame = convert(bounds, to: nil)
		let bottomOfScrollView = visibleScrollFrame.maxY
		if bottomOfScrollView > keyboardRect.origin.y {
			let cutHeight = bottomOfScrollView - keyboardRect.origin.y
			visibleScrollFrame.size.height -= cutHeight
			UIView.animate(withDuration: keyboardAnimationDuration, animations: {
				self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, self.scrollView.contentInset.left, cutHeight, self.scrollView.contentInset.right)
			}, completion: nil)
		}
	}
}

