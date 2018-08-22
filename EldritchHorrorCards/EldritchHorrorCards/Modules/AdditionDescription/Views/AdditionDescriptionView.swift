//
//  AdditionDescriptionView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 8/22/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol AdditionDescriptionViewDelegate: class {
	func backButtonTap()
}

extension AdditionDescriptionView {
	
	struct Appearance {
	}
}

class AdditionDescriptionView: UIView {
	var delegate: AdditionDescriptionViewDelegate?
	
	private let appearance = Appearance()
	private var viewModel: Addition!
	
	lazy var backButton: UIButton = {
		let view = UIButton()
		view.setTitle("", for: .normal)
		view.setImage(.backButton, for: .normal)
		return view
	}()
	
	lazy var titleLabel: UILabel = {
		let view = UILabel()
		view.textColor = .mako
		view.text = viewModel.name
		view.font = UIFont.bold24
		return view
	}()
	
	lazy var textView: UITextView = {
		let view = UITextView()
		view.text = viewModel.description
		view.font = UIFont.bold16
		view.textColor = .mako
		view.isEditable = false
		view.isSelectable = false
		return view
	}()
	
	init(frame: CGRect = CGRect.zero, viewModel: Addition) {
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
			make.top.equalToSuperview().inset(50)
			make.left.equalToSuperview().inset(30)
			make.width.height.equalTo(30)
		}
		
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalTo(backButton.snp.bottom).offset(30)
			make.left.right.equalToSuperview().inset(33)
		}
		
		textView.snp.makeConstraints { (make) in
			make.top.equalTo(titleLabel.snp.bottom)
			make.left.right.bottom.equalToSuperview().inset(30)
		}
	}
	
	@objc private func backButtonPressed() {
		delegate?.backButtonTap()
	}
}
