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

class MenuContentView: BaseScrollView {
	weak var delegate: MenuContentViewDelegate?
	
	public func update(name: String, avatar: UIImage?) {
		avatarView.update(avatar: avatar)
		userName.text = name
	}
	
	//MARK: -
	
	private lazy var avatarView: AvatarView = {
		let avatar = AvatarView()
		return avatar
	}()
	
	private lazy var userName: UILabel = {
		let label = UILabel()
		label.font = UIFont.bold28
		label.textAlignment = .center
		label.numberOfLines = 0
		label.textColor = UIColor.scorpion
		label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
		return label
	}()
	
	private lazy var separatorLineView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.scorpion
		return view
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor = UIColor.wildSand
		addSubviews()
		makeConstraints()
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSeparatorView(height: 50, expandable: false)
		addToStackView(view: avatarView, embed: true)
		addSeparatorView(height: 15, expandable: false)
		addToStackView(view: userName, embed: true)
		addSeparatorView(height: 10, expandable: false)
		addToStackView(view: separatorLineView, embed: true)
		addSeparatorView(height: 10, expandable: true)
	}
	
	private func makeConstraints() {
		avatarView.snp.makeConstraints { (make) in
			make.width.height.equalTo(150)
			make.centerX.equalToSuperview()
		}
		
		userName.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(0.9)
		}
		
		separatorLineView.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(0.9)
			make.height.equalTo(1)
			make.centerX.equalToSuperview()
		}
	}
	
	override func updateHeight() {
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height - 64)
	}
}
