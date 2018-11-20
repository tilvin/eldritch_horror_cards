//
//  PartnersListView.swift
//  Ebs
//
//  Created by Ильнур Ягудин on 19.07.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit
import SnapKit

protocol AdditionsListViewDelegate: class {
	func menuButtonAction()
	func continueButtonAction()
}

extension AdditionsListView {
	
	struct Appearance {
		let tableViewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
		let backgroundColor = UIColor.clear
		let titleLabelTopOffset: CGFloat = 52
		let titleLabelLeftOffset: CGFloat = 50
		let titleLabelRightOffset: CGFloat = 20
		let tableViewBottomOffset: CGFloat = -10
		let continueButtonHeight: CGFloat = 50
		let continueButtonLeftOffset: CGFloat = 30
		let continueButtonBottomOffset: CGFloat = 32
	}
}

final class AdditionsListView: UIView {
	
	//MARK: - Public variables
	
	weak var delegate: AdditionsListViewDelegate?
	
	//MARK: - Private variables
	
	private let appearance = Appearance()
	
	//MARK: - Lazy variables
	
	private lazy var menuButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage.menuButton, for: .normal)
		button.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
		return button
	}()
	
	lazy var menuContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .mako
		label.text = "additions.title".localized
		label.font = UIFont.bold24
		label.numberOfLines = 0
		return label
	}()
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = appearance.backgroundColor
		view.contentInset = appearance.tableViewContentInsets
		return view
	}()
	
	lazy var continueButton: CustomButton = {
		let button = CustomButton(type: .darkGreenBlue)
		button.setTitle("additions.button.continue".localized.capitalized, for: .normal)
		return button
	}()
	
	//MARK: - Init
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor = appearance.backgroundColor
		titleLabel.textAlignment = .center
		addSubviews()
		makeConstraints()
		continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("required init!")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(titleLabel)
		addSubview(tableView)
		addSubview(continueButton)
		addSubview(menuButton)
		addSubview(menuContainer)
		backgroundColor = UIColor.clear
	}
	
	private func makeConstraints() {
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(appearance.titleLabelTopOffset)
			make.left.equalTo(menuButton).offset(appearance.titleLabelLeftOffset)
			make.right.equalToSuperview().inset(appearance.titleLabelRightOffset)
		}
		
		tableView.snp.makeConstraints { (make) in
			make.top.equalTo(titleLabel.snp.bottom)
			make.left.right.equalToSuperview()
			make.bottom.equalTo(continueButton.snp.top).offset(appearance.tableViewBottomOffset)
		}
		
		continueButton.snp.makeConstraints { (make) in
			make.height.equalTo(appearance.continueButtonHeight)
			make.left.right.equalToSuperview().inset(appearance.continueButtonLeftOffset)
			make.bottom.equalToSuperview().inset(appearance.continueButtonBottomOffset)
		}
		
		menuContainer.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		menuButton.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.top.equalToSuperview().inset(28)
			make.width.height.equalTo(70)
		}
	}
	
	//MARK: - Handlers
	
	@objc private func continueButtonPressed() {
		delegate?.continueButtonAction()
		
	}
	
	@objc private func menuButtonAction() {
		delegate?.menuButtonAction()
	}
}
