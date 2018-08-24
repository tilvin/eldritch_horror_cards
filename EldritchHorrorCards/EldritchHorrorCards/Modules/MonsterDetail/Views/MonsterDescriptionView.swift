//
//  MonsterDescriptionView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/31/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

struct Appearance {
	let tableViewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
	let backgroundColorTextView = UIColor.darkGreenBlue
	let textColor = UIColor.white
	let cornerRadiusTextView: CGFloat = 15
	let fontTextView = UIFont.regular14
	let backgroundColor = UIColor.wildSand
	let textViewlLeftOffset: CGFloat = 10
	let textViewTopOffset: CGFloat = 60
	let closeButtonWidth: CGFloat = 25
	let closeButtonTop: CGFloat = 30
	let closeButtonRight: CGFloat = 10
}
protocol MonsterDescriptionViewDelegate: class {
	func closeButtonPressed()
}

final class MonsterDescriptionView: UIView {
	private var viewModel: Monster!
	weak var delegate: MonsterDescriptionViewDelegate?
	let appearance = Appearance()
	
	//MARK: -
	
	private lazy var descriptionTextView: UITextView = {
		let tv = UITextView()
		tv.font = appearance.fontTextView
		tv.backgroundColor = appearance.backgroundColorTextView
		tv.textColor = appearance.textColor
		tv.layer.cornerRadius = appearance.cornerRadiusTextView
		tv.clipsToBounds = true
		tv.text = viewModel.other
		return tv
	}()
	
	
	private lazy var closeButtonView: CloseButtonView = {
		return CloseButtonView()
	}()
	
	//MARK: - Lifecycle
	
	init(frame: CGRect = CGRect.zero, viewModel: Monster) {
		super.init(frame: frame)
		backgroundColor = appearance.backgroundColor
		self.viewModel = viewModel
		addSubviews()
		makeConstraints()
		closeButtonView.closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(descriptionTextView)
		addSubview(closeButtonView)
	}
	
	private func makeConstraints() {
		descriptionTextView.snp.makeConstraints { (make) in
			make.left.right.bottom.equalToSuperview().inset(appearance.textViewlLeftOffset)
			make.top.equalToSuperview().inset(appearance.textViewTopOffset)
		}
		
		closeButtonView.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(appearance.closeButtonTop)
			make.right.equalToSuperview().inset(appearance.closeButtonRight)
			make.width.height.equalTo(appearance.closeButtonWidth)
		}
	}
	
	@objc private func closeButtonTap() {
		delegate?.closeButtonPressed()
	}
}
