//
//  ExpeditionView.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 12/10/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

protocol ExpeditionViewDelegate: class {
	func backButtonTap()
}

extension PlotStoryView {
	
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
		let sectionViewHeight: CGFloat = 140
		let descriptionTextViewHeight: CGFloat = ScreenType.item(for: (.inch4, 90), (.inch5_5, 72))
		let markViewDefault: CGFloat = 8
		let statusBarHeight: CGFloat = 20
		let defaultSeparator: CGFloat = 20
		let titleCornerRadius: CGFloat = 20
		let titleOpacity: Float = 0.5
	}
}

class PlotStoryView: BaseScrollView {
	
	public weak var delegate: ExpeditionViewDelegate?
	private let appearance = Appearance()
	
	//MARK: - Private lazy variables
	
	private lazy var backButton: CustomButton = {
		return CustomButton(type: .back)
	}()
	
	private lazy var titleImageView: UIImageView = {
		let view = UIImageView(with: .pyramids, contentMode: UIViewContentMode.scaleAspectFill )
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var titleLabelView: UIView = {
		let view = UIView(backgroundColor: .mako)
		view.clipsToBounds = true
		view.layer.cornerRadius = appearance.titleCornerRadius
		view.layer.opacity = appearance.titleOpacity
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
	
	private lazy var successView: CardSectionView = {
		return CardSectionView()
	}()
	
	private lazy var failureView: CardSectionView = {
		return CardSectionView()
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
	
	//MARK: - Lifecycle
	
	init(frame: CGRect = CGRect.zero, viewModel: PlotStoryViewModel) {
		super.init(frame: frame)
		titleImageView.image = viewModel.image
		titleLabel.text = viewModel.title
		descriptionTextView.text = viewModel.story
		backgroundColor = appearance.backgroundColor
		update(viewModel: viewModel)
		addSubviews()
		makeConstraints()
		backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	public func update(viewModel: PlotStoryViewModel) {
		titleImageView.image = viewModel.image
		titleLabel.text = viewModel.title
		successView.update(viewModel: viewModel.successViewModel)
		failureView.update(viewModel: viewModel.failureViewModel)
		descriptionTextView.text = viewModel.story
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
		addSeparatorView(height: appearance.defaultSeparator)
		addToStackView(view: failureView, embed: true)
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
			make.height.equalTo(appearance.sectionViewHeight)
			make.left.right.equalToSuperview().inset(appearance.defaultSideOffset)
			make.top.bottom.equalToSuperview()
		}
		
		failureView.snp.remakeConstraints { (make) in
			make.height.equalTo(appearance.sectionViewHeight)
			make.left.right.equalToSuperview().inset(appearance.defaultSideOffset)
			make.top.bottom.equalToSuperview()
		}
	}
	
	override func updateHeight() {
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height)
	}
	
	//MARK: - Handlers
	
	@objc private func backButtonPressed() {
		delegate?.backButtonTap()
	}
}
