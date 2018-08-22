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
	}
}

class AdditionsListView: UIView {
	
	let appearance = Appearance()
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .mako
		label.text = "additions.title".localized
		label.font = UIFont.bold32
		return label
	}()
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = appearance.backgroundColor
		view.contentInset = appearance.tableViewContentInsets
		return view
	}()
	
	lazy var button: UIButton = {
		let button = UIButton()
		button.setTitle("Test", for: .normal)
		button.backgroundColor = .gray
		return button
	}()
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor = appearance.backgroundColor
		addSubviews()
		makeConstraints()
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
		addSubview(button)
		backgroundColor = UIColor.clear
	}
	
	private func makeConstraints() {
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(52)
			make.left.right.equalToSuperview().offset(25)
		}
		
		tableView.snp.makeConstraints { (make) in
			make.top.equalTo(titleLabel.snp.bottom)
			make.left.right.equalToSuperview()
			make.bottom.equalTo(button.snp.top).offset(-10)
		}
		
		button.snp.makeConstraints { (make) in
			make.height.equalTo(45)
			make.left.right.equalToSuperview().inset(50)
			make.bottom.equalToSuperview().inset(32)
		}
	}
}
