//
//  LocalStoryView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 12/24/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

protocol LocalStoryViewDelegate: class {
	func backButtonPressed()
}

extension LocalStoryView {
	
	struct Appearance {
		let elementSpacing: CGFloat = 10
		let verticalOffset: CGFloat = 15
		let viewHeight: CGFloat = 150
		let topOffset: CGFloat = 80
		let backButtonTopOffset: CGFloat = 35
	}
}

class LocalStoryView: BaseScrollView {
	
	weak var delegate: LocalStoryViewDelegate?
	
	//MARK: - Private
	
	private let appearance = Appearance()
	
	//MARK: - Private lazy variables
	
	private lazy var backButton: CustomButton = {
		return CustomButton(type: .back)
	}()
	
	private lazy var topTitleLabel: UILabel = {
		return UILabel(font: .light22, textColor: .mako)
	}()
	
	private lazy var topView: CardSectionView = {
		return CardSectionView()
	}()
	
	private lazy var middleTitleLabel: UILabel = {
		return UILabel(font: .light22, textColor: .mako)
	}()
	
	private lazy var middleView: CardSectionView = {
		return CardSectionView()
	}()
	
	private lazy var bottomTitleLabel: UILabel = {
		return UILabel(font: .light22, textColor: .mako)
	}()
	
	private lazy var bottomView: CardSectionView = {
		return CardSectionView()
	}()
	
	//MARK: - Lifecycle 
	
	init(frame: CGRect = .zero, viewModel: LocalStoryViewModel) {
		super.init(frame: frame)
		backgroundColor = .white
		topTitleLabel.text = viewModel.topTitle
		topView.update(viewModel: viewModel.topViewModel)
		middleTitleLabel.text = viewModel.middleTitle
		middleView.update(viewModel: viewModel.middleViewModel)
		bottomTitleLabel.text = viewModel.bottomTitle
		bottomView.update(viewModel: viewModel.bottomViewModel)
		backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
		addSubviews()
		makeContraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("use INIT!")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(backButton)
		addSeparatorView(height: appearance.topOffset)
		addToStackView(view: topTitleLabel, embed: true)
		addSeparatorView(height: appearance.elementSpacing)
		addToStackView(view: topView, embed: true)
		addSeparatorView(height: appearance.elementSpacing)
		addToStackView(view: middleTitleLabel, embed: true)
		addSeparatorView(height: appearance.elementSpacing)
		addToStackView(view: middleView, embed: true)
		addSeparatorView(height: appearance.elementSpacing)
		addToStackView(view: bottomTitleLabel, embed: true)
		addSeparatorView(height: appearance.elementSpacing)
		addToStackView(view: bottomView, embed: true)
		addSeparatorView(height: appearance.verticalOffset, expandable: true)
	}
	
	private func makeContraints() {
		backButton.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(appearance.backButtonTopOffset)
			make.left.equalToSuperview().inset(DefaultAppearance.sideOffset)
			make.width.height.equalTo(DefaultAppearance.backButtonWidth)
		}
		
		topTitleLabel.snp.makeConstraints { (make) in
			make.left.equalToSuperview().inset(DefaultAppearance.sideOffset)
			make.centerX.equalToSuperview()
			make.top.bottom.equalToSuperview()
		}
		
		topView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().inset(DefaultAppearance.sideOffset)
			make.centerX.equalToSuperview()
			make.top.bottom.equalToSuperview()
			make.height.equalTo(appearance.viewHeight)
		}
		
		middleTitleLabel.snp.makeConstraints { (make) in
			make.left.equalToSuperview().inset(DefaultAppearance.sideOffset)
			make.centerX.equalToSuperview()
			make.top.bottom.equalToSuperview()
		}
		
		middleView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().inset(DefaultAppearance.sideOffset)
			make.centerX.equalToSuperview()
			make.top.bottom.equalToSuperview()
			make.height.equalTo(appearance.viewHeight)
		}
		
		bottomTitleLabel.snp.makeConstraints { (make) in
			make.left.equalToSuperview().inset(DefaultAppearance.sideOffset)
			make.centerX.equalToSuperview()
			make.top.bottom.equalToSuperview()
		}
		
		bottomView.snp.makeConstraints { (make) in
			make.left.equalToSuperview().inset(DefaultAppearance.sideOffset)
			make.centerX.equalToSuperview()
			make.top.bottom.equalToSuperview()
			make.height.equalTo(appearance.viewHeight)
		}
	}
	
	override func updateHeight() {
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height)
	}
	
	//MARK: - Handlers
	
	@objc
	private func backButtonAction() {
		delegate?.backButtonPressed()
	}
}
