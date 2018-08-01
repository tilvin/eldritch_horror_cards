//
//  CloseButtonView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/31/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

class CloseButtonView: DesignableView {

	fileprivate(set) lazy var closeButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.closeButton, for: .normal)
		return button
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		self.computeCornerRadius = true
		self.shadowOffset = CGPoint.zero
		self.shadowOpacity = 1
		self.shadowRadius = 5
		self.shadowColor = UIColor.white
		addSubviews()
		makeConstraints()
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(closeButton)
	}
	
	private func makeConstraints() {
		closeButton.snp.makeConstraints { (make) in
			make.centerX.centerY.equalToSuperview()
		}
	}
}
