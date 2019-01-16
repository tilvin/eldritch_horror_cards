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
	func closeButtonPressed()
}

extension DescriptionView {
	
	struct Appearance {
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
	private lazy var closeButton: CustomButton = {
		let view = CustomButton(type: .close)
		view.setImage(UIImage.closeButton, for: .normal)
		view.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
		return view
	}()
	
	private lazy var titleLabel: UILabel = {
		let view = UILabel()
		view.textColor = appearance.textColor
		view.text = viewModel.name
		view.numberOfLines = 0
		view.font = UIFont.bold24
		return view
	}()
	
	private lazy var textView: UITextView = {
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
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(closeButton)
		addSubview(titleLabel)
		addSubview(textView)
	}
	
	private func makeConstraints() {
		closeButton.snp.makeConstraints { (make) in
			make.top.equalTo(safeAreaLayoutGuide.snp.topMargin).inset(DefaultAppearance.closeTopOffset)
			make.right.equalToSuperview().inset(DefaultAppearance.closeRightOffset)
			make.width.height.equalTo(DefaultAppearance.closeSizeWH)
		}
		
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalTo(closeButton.snp.bottom).inset(appearance.titleTopOffset)
			make.left.right.equalToSuperview().inset(appearance.titleLeftOffset)
		}
		
		textView.snp.makeConstraints { (make) in
			make.top.equalTo(closeButton.snp.bottom).offset(appearance.textViewOffset)
			make.left.right.bottom.equalToSuperview().inset(appearance.textViewOffset)
		}
	}
	
	@objc
	private func closeButtonPressed() {
		delegate?.closeButtonPressed()
	}
}
