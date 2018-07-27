//
//  MenuView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/27/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol MenuViewDelegate: class {
	func backgroundTap()
}

extension MenuView {
	
	struct Appearance {
		let verticalOffset: (low: CGFloat, mid: CGFloat, high: CGFloat) = (16, 24, 32)
		let linkButtonHeight: CGFloat = 24
		let statusBarHeight: CGFloat = 20
		let navigationHeight: CGFloat = 44
		
		let leftOffset: CGFloat = 16
		let buttonHeight: CGFloat = 56
		let horizontalStackViewSpacing: CGFloat = 33
		
	}
}

class MenuView: UIView {
	private let appearance = Appearance()
	weak var delegate: MenuViewDelegate?
	
	fileprivate(set) lazy var contentView: MenuContentView = {
		return MenuContentView()
	}()

	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor = UIColor.black.withAlphaComponent(0.8)
		addSubviews()
		makeConstraints()
		let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
		addGestureRecognizer(gesture)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(contentView)
		
//		addSeparatorView(height: appearance.verticalOffset.mid, expandable: false)
//		addToStackView(view: headView, embed: true)
//		addSeparatorView(height: appearance.verticalOffset.mid, expandable: false)
//		addToStackView(view: descriptionLabel, embed: true)
//		addSeparatorView(height: appearance.verticalOffset.low, expandable: false)
//		addToStackView(view: buttonStackView, embed: true)
//		addSeparatorView(height: appearance.verticalOffset.high, expandable: true)
//		addToStackView(view: invalidButton, embed: true)
//		addSeparatorView(height: appearance.verticalOffset.mid, expandable: false)
//		addToStackView(view: backToAppButton, embed: true)
//		addSeparatorView(height: appearance.verticalOffset.mid, expandable: false)
	}
	
	private func makeConstraints() {
		contentView.snp.makeConstraints { (make) in
			make.left.top.bottom.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(0.8)
		}

	}
	
	@objc
	private func backgroundTap() {
		delegate?.backgroundTap()
	}
}
