//
//  AdditionDescriptionView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 8/22/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol DescriptionViewDelegate: class {
	func backButtonTap()
}

extension DescriptionView {
	
	struct Appearance {
		let backButtonTopOffset: CGFloat = 50
		let backButtonLeftOffset: CGFloat = 30
		let backButtonHeight: CGFloat = 30
		let titleTopOffset: CGFloat =  27
		let titleLeftOffset: CGFloat = 80
		let textViewOffset: CGFloat = 30
		let textColor: UIColor = UIColor.mako
	}
}

class DescriptionView: UIView {
	var delegate: DescriptionViewDelegate?
	
	private let appearance = Appearance()
	private var viewModel: Description!
	
	lazy var backButton: UIButton = {
		let view = UIButton()
		view.setTitle("", for: .normal)
		view.setImage(.backButton, for: .normal)
		return view
	}()
	
	lazy var titleLabel: UILabel = {
		let view = UILabel()
		view.textColor = appearance.textColor
		view.text = viewModel.name
		view.numberOfLines = 0
		view.font = UIFont.bold24
		return view
	}()
	
	lazy var textView: UITextView = {
		let view = UITextView()
		view.text = viewModel.description
		view.font = UIFont.bold16
		view.textColor = appearance.textColor
		view.isEditable = false
		view.isSelectable = false
		return view
	}()
	
	init(frame: CGRect = CGRect.zero, viewModel: Description) {
		super.init(frame: frame)
		self.viewModel = viewModel
		self.backgroundColor = .white
		addSubviews()
		makeConstraints()
		backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(backButton)
		addSubview(titleLabel)
		addSubview(textView)
	}
	
	private func makeConstraints() {
		backButton.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(appearance.backButtonTopOffset)
			make.left.equalToSuperview().inset(appearance.backButtonLeftOffset)
			make.width.height.equalTo(appearance.backButtonHeight)
		}
		
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalTo(backButton.snp.bottom).inset(appearance.titleTopOffset)
			make.left.right.equalToSuperview().inset(appearance.titleLeftOffset)
		}
		
		textView.snp.makeConstraints { (make) in
			make.top.equalTo(backButton.snp.bottom).offset(appearance.textViewOffset)
			make.left.right.bottom.equalToSuperview().inset(appearance.textViewOffset)
		}
	}
	
	@objc private func backButtonPressed() {
		delegate?.backButtonTap()
	}
}
