//
//  ExpeditionView.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol ExpeditionViewDelegate: class {
	func backButtonTap()
}

extension ExpeditionView {
	
	struct Appearance {
		let backButtonTopOffset: CGFloat = 50
		let backButtonLeftOffset: CGFloat = 30
		let backButtonHeight: CGFloat = 30
		let backgroundColor = UIColor.clear
		let defaultSideOffset: CGFloat = 25
		let titleLabelViewOffset: CGFloat = 5
		let titleLabelViewHeight: CGFloat = 40
		let titleLabelViewWidth: CGFloat = 150
		let titleImageViewHeight: CGFloat = 151
		let descriptionTextViewHeight: CGFloat = ScreenType.item(for: (.inch4, 90), (.inch5_5, 72))
		let successFailureViewHeight: CGFloat = 140
		let successFailureTextViewRight: CGFloat = ScreenType.item(for: (.inch4, 0), (.inch5_5, 24))
		let successFailureTextViewTopBottom: CGFloat = ScreenType.item(for: (.inch4, 0), (.inch5_5, 16))
		let markViewDefault: CGFloat = 8
		let statusBarHeight: CGFloat = 20
		let defaultSeparator: CGFloat = 20
	}
}

class ExpeditionView: BaseScrollView {
	
	var delegate: ExpeditionViewDelegate?
	
	//MARK: - Private variables
	
	private let appearance = Appearance()
	private var viewModel: ExpeditionViewModel!
	
	//MARK: - Private lazy variables
	
	private lazy var backButton: UIButton = {
		let view = UIButton()
		view.setTitle("", for: .normal)
		view.setImage(.backButton, for: .normal)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
		return view
	}()
	
	private lazy var titleImageView: UIImageView = {
		let view = UIImageView(with: .pyramids, contentMode: UIViewContentMode.scaleAspectFill )
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var titleLabelView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 20
		view.layer.opacity = 0.5
		view.backgroundColor = .mako
		return view
	}()
	
	private lazy var titleLabel: UILabel = {
		return UILabel(font: .bold24, textColor: .gallery)
	}()
	
	private lazy var descriptionTextView: UITextView = {
		let view = UITextView()
		view.isEditable = false
		view.textColor = .mako
		view.textAlignment = .left
		view.font = .bold14
		view.isScrollEnabled = false
		return view
	}()
	
	private lazy var successView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 8
		view.backgroundColor = .gallery
		return view
	}()
	
	private lazy var successTextView: UITextView = {
		let view = UITextView()
		view.isEditable = false
		view.textColor = .mako
		view.backgroundColor = .clear
		view.textAlignment = .left
		view.font = .regular14
		return view
	}()
	
	private lazy var failureView: UIView = {
		let view = UIView()
		view.clipsToBounds = true
		view.layer.cornerRadius = 8
		view.backgroundColor = .paleSalmon
		return view
	}()
	
	private lazy var failureTextView: UITextView = {
		let view = UITextView()
		view.isEditable = false
		view.textColor = .mako
		view.backgroundColor = .clear
		view.textAlignment = .left
		view.font = .regular14
		return view
	}()
	
	private lazy var markSuccessView: UIView = {
		let view = UIView()
		view.backgroundColor = .whiteTwo
		view.layer.cornerRadius = 4
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var markFailureView: UIView = {
		let view = UIView()
		view.backgroundColor = .whiteTwo
		view.layer.cornerRadius = 4
		view.clipsToBounds = true
		return view
	}()
	
	//MARK: - Init
	
	init(frame: CGRect = CGRect.zero, viewModel: ExpeditionViewModel) {
		super.init(frame: frame)
		self.viewModel = viewModel
		titleImageView.image = viewModel.image
		titleLabel.text = viewModel.title
		descriptionTextView.text = viewModel.story
		successTextView.text = viewModel.success
		failureTextView.text = viewModel.failure
		backgroundColor = appearance.backgroundColor
		addSubviews()
		makeConstraints()
		backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	public func update(viewModel: ExpeditionViewModel) {
		self.viewModel = viewModel
		titleImageView.image = viewModel.image
		titleLabel.text = viewModel.title
		descriptionTextView.text = viewModel.story
		successTextView.text = viewModel.success
		failureTextView.text = viewModel.failure
		backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(backButton)
		addSeparatorView(height: appearance.defaultSeparator)
		addToStackView(view: titleImageView, embed: true)
		titleImageView.addSubview(titleLabelView)
		titleImageView.addSubview(titleLabel)
		addSeparatorView(height: appearance.defaultSeparator)
		addToStackView(view: descriptionTextView, embed: true)
		addSeparatorView(height: appearance.defaultSeparator)
		addToStackView(view: successView, embed: true)
		successView.addSubview(successTextView)
		successView.addSubview(markSuccessView)
		addSeparatorView(height: appearance.defaultSeparator)
		addToStackView(view: failureView, embed: true)
		failureView.addSubview(failureTextView)
		failureView.addSubview(markFailureView)
		addSeparatorView(expandable: true)
	}
	
	private func makeConstraints() {
		
		backButton.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(appearance.backButtonTopOffset)
			make.left.equalToSuperview().inset(appearance.backButtonLeftOffset)
			make.width.height.equalTo(appearance.backButtonHeight)
		}
		
		titleImageView.snp.remakeConstraints { (make) in
			make.top.bottom.equalToSuperview()
			make.height.equalTo(appearance.titleImageViewHeight)
			make.width.equalToSuperview()
		}
		
		titleLabel.snp.makeConstraints { (make) in
			make.centerY.equalTo(titleLabelView)
			make.left.right.equalTo(titleLabelView).inset(appearance.defaultSideOffset)
		}
		
		titleLabelView.snp.makeConstraints { (make) in
			make.left.bottom.equalToSuperview().inset(appearance.titleLabelViewOffset)
			make.height.equalTo(appearance.titleLabelViewHeight)
			make.width.greaterThanOrEqualToSuperview().inset(appearance.titleLabelViewWidth)
		}
		
		descriptionTextView.snp.remakeConstraints { (make) in
			make.height.greaterThanOrEqualTo(appearance.descriptionTextViewHeight)
			make.left.right.equalToSuperview().inset(appearance.defaultSideOffset)
			make.top.bottom.equalToSuperview()
		}
		
		successView.snp.remakeConstraints { (make) in
			make.height.equalTo(appearance.successFailureViewHeight)
			make.left.right.equalToSuperview().inset(appearance.defaultSideOffset)
			make.top.bottom.equalToSuperview()
		}
		
		successTextView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().inset(appearance.defaultSideOffset)
			make.right.equalToSuperview().inset(appearance.successFailureTextViewRight)
			make.top.bottom.equalToSuperview().inset(appearance.successFailureTextViewTopBottom)
		}
		
		failureView.snp.remakeConstraints { (make) in
			make.height.equalTo(appearance.successFailureViewHeight)
			make.left.right.equalToSuperview().inset(appearance.defaultSideOffset)
			make.top.bottom.equalToSuperview()
		}
		
		failureTextView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().inset(appearance.defaultSideOffset)
			make.right.equalToSuperview().inset(appearance.successFailureTextViewRight)
			make.top.bottom.equalToSuperview().inset(appearance.successFailureTextViewTopBottom)
		}
		
		markSuccessView.snp.makeConstraints { (make) in
			make.width.height.equalTo(appearance.markViewDefault)
			make.left.top.equalToSuperview().inset(appearance.markViewDefault)
		}
		
		markFailureView.snp.makeConstraints { (make) in
			make.width.height.equalTo(appearance.markViewDefault)
			make.left.top.equalToSuperview().inset(appearance.markViewDefault)
		}
	}
	
	override func updateHeight() {
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height)
	}
	
	@objc private func backButtonPressed() {
		delegate?.backButtonTap()
	}
}
