//
//  PartnersListView.swift
//  Ebs
//
//  Created by Ильнур Ягудин on 19.07.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

extension AdditionsListView {
	
	struct Appearance {
		let tableViewContentInsets = UIEdgeInsetsMake(0, 0, 0, 0)
		let backgroundColor = UIColor.clear
	}
}

class AdditionsListView: UIView {
	
	let appearance = Appearance()
	
	lazy var tableView: UITableView = {
		let view = UITableView()
		view.backgroundColor = appearance.backgroundColor
		view.contentInset = appearance.tableViewContentInsets
		return view
	}()
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor = appearance.backgroundColor
		addSubviews()
		makeConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		addSubviews()
		makeConstraints()
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(tableView)
		backgroundColor = UIColor.clear
	}
	
	private func makeConstraints() {
		tableView.snp.makeConstraints { (maker) in
			maker.edges.equalToSuperview()
		}
	}
}
