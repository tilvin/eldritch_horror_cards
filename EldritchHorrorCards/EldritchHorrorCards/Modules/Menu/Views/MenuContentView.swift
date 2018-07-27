//
//  MenuContentView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/27/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol MenuContentViewDelegate: class {
	
}

extension MenuContentView {
	
	struct Appearance {
	}
}

class MenuContentView: BaseScrollView {
	private let appearance = Appearance()
	weak var delegate: MenuContentViewDelegate?
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Menu title!"
		label.textAlignment = .center
		return label
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor = UIColor.white
		addSubviews()
		makeConstraints()
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSeparatorView(height: 40, expandable: false)
		addToStackView(view: titleLabel, embed: true)
		addSeparatorView(height: 10, expandable: true)
	}
	
	private func makeConstraints() {
		titleLabel.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(20)
		}
		
	}
}
