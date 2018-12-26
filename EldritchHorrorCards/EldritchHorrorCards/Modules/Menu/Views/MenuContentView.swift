//
//  MenuContentView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/27/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol MenuContentViewProtocol: class {
	func turnHistoryPressed()
	func locationPressed()
	func logoutButtonPressed()
}

class MenuContentView: BaseScrollView {
	weak var delegate: MenuContentViewProtocol?
	
	public func update(name: String, avatar: UIImage?) {
		avatarView.update(avatar: avatar)
		userName.text = name
	}
	
	//MARK: -
	
	private lazy var avatarView: AvatarView = {
		return AvatarView()
	}()
	
	private lazy var userName: UILabel = {
		let label = UILabel()
		label.font = UIFont.bold28
		label.textAlignment = .center
		label.numberOfLines = 0
		label.textColor = UIColor.wildSand
		label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
		return label
	}()
	
	private lazy var separatorLineView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.wildSand
		return view
	}()
	
	private lazy var turnHistoryButton: UIButton = {
		let button = UIButton()
		button.setTitle("menu.turnHistory.button.label".localized, for: .normal)
		button.contentHorizontalAlignment = .left
		button.setTitleColor(.wildSand, for: .normal)
		return button
	}()
	
	private lazy var locationButton: UIButton = {
		let button = UIButton()
		button.setTitle("menu.location.button.label".localized, for: .normal)
		button.contentHorizontalAlignment = .left
		button.setTitleColor(.wildSand, for: .normal)
		return button
	}()
	
	private lazy var logoutButton: UIButton = {
		let button = UIButton()
		button.setTitle("menu.logout.button.label".localized, for: .normal)
		button.titleLabel?.textAlignment = .left
		button.setTitleColor(.wildSand, for: .normal)
		return button
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		scrollView.backgroundColor =  UIColor.viridianTwo.withAlphaComponent(0.95)
		addSubviews()
		makeConstraints()
		layoutIfNeeded()
		turnHistoryButton.addTarget(self, action: #selector(turnHistoryButtonPressed), for: .touchUpInside)
		locationButton.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
		logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
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
		addSeparatorView(height: 10, expandable: false)
		addToStackView(view: turnHistoryButton, embed: true)
		addSeparatorView(height: 10, expandable: false)
		addToStackView(view: locationButton, embed: true)
		addSeparatorView(height: 10, expandable: false)
		addToStackView(view: logoutButton, embed: true)
		addSeparatorView(height: 34, expandable: false)
	}
	
	private func makeConstraints() {
		avatarView.snp.removeConstraints()
		avatarView.snp.makeConstraints { (make) in
			make.width.height.equalTo(150)
			make.top.bottom.equalToSuperview()
			make.centerX.equalToSuperview()
		}
		
		userName.snp.removeConstraints()
		userName.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(0.9)
			make.top.bottom.equalToSuperview()
			make.centerX.equalToSuperview()
		}
		
		separatorLineView.snp.removeConstraints()
		separatorLineView.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(0.9)
			make.height.equalTo(1)
			make.top.bottom.equalToSuperview()
			make.centerX.equalToSuperview()
		}
		
		turnHistoryButton.snp.removeConstraints()
		turnHistoryButton.snp.makeConstraints { make in
			make.height.equalTo(24)
			make.top.bottom.equalToSuperview()
			make.width.equalToSuperview()
			make.leading.equalToSuperview().offset(32)
		}
		
		locationButton.snp.removeConstraints()
		locationButton.snp.makeConstraints { make in
			make.height.equalTo(24)
			make.top.bottom.equalToSuperview()
			make.width.equalToSuperview()
			make.leading.equalToSuperview().offset(32)
		}
		
		logoutButton.snp.removeConstraints()
		logoutButton.snp.makeConstraints { make in
			make.height.equalTo(24)
			make.top.bottom.equalToSuperview()
			make.leading.equalToSuperview().offset(32)
		}
	}
	
	@objc private func turnHistoryButtonPressed() {
		delegate?.turnHistoryPressed()
	}
	
	@objc private func locationButtonPressed() {
		delegate?.locationPressed()
	}
	
	@objc private func logoutButtonPressed() {
		delegate?.logoutButtonPressed()
	}
	
	override func updateHeight() {
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height - 64)
	}
}
