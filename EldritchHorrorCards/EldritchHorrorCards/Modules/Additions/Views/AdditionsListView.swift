//
//  PartnersListView.swift
//  Ebs
//
//  Created by Ильнур Ягудин on 19.07.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit
import SnapKit

extension AdditionsListView {
	
	struct Appearance {
		let tableViewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
		let backgroundColor = UIColor.clear
		let titleLabelTopOffset: CGFloat = 52
		let titleLabelLeftOffset: CGFloat = 20
		let tableViewBottomOffset: CGFloat = -10
		let continueButtonHeight: CGFloat = 50
		let continueButtonLeftOffset: CGFloat = 30
		let continueButtonBottomOffset: CGFloat = 32
	}
}

class AdditionsListView: UIView {
	
	let appearance = Appearance()
	
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
		super.init(coder: aDecoder)
		addSubviews()
		makeConstraints()
		layoutIfNeeded()
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(titleLabel)
		addSubview(tableView)
		addSubview(continueButton)
		backgroundColor = UIColor.clear
	}
	
	private func makeConstraints() {
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(appearance.titleLabelTopOffset)
			make.left.right.equalToSuperview().inset(appearance.titleLabelLeftOffset)
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
	}
	
	@objc private func continueButtonPressed() {
		print("continueButton pressed!")
	}
}
