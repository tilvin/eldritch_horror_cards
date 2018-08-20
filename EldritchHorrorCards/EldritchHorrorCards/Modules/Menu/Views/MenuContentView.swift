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
	func testButtonPressed()
	func logOffButtonPressed()
}

class MenuContentView: BaseScrollView {
	weak var delegate: MenuContentViewProtocol?

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
		label.textColor = UIColor.wildSand
		label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
		return label
	}()
	
	private lazy var separatorLineView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor.wildSand
		return view
	}()

	private lazy var testButton: UIButton = {
		let button = UIButton()
		button.setTitle("TestButton", for: .normal)
		button.backgroundColor = .darkGray
		button.setTitleColor(.red, for: .normal)
		return button
	}()
	
	private lazy var logOffButton: UIButton = {
		let button = UIButton()
		button.setTitle("menu.logOff.button.lable".localized, for: .normal)
		button.titleLabel?.textAlignment = .center
		button.setTitleColor(.wildSand, for: .normal)
		return button
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor =  UIColor.viridianTwo.withAlphaComponent(0.95)
		addSubviews()
		makeConstraints()
		layoutIfNeeded()

		testButton.addTarget(self, action: #selector(testButtonPressed), for: .touchUpInside)
		logOffButton.addTarget(self, action: #selector(logOffButtonPressed), for: .touchUpInside)
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
		addToStackView(view: testButton, embed: true)
		addSeparatorView(height: 10, expandable: true)
		addToStackView(view: logOffButton, embed: true)
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

		testButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.width.equalToSuperview()
		 }
		
		logOffButton.snp.makeConstraints { make in
			make.height.equalTo(50)
			make.width.equalToSuperview().multipliedBy(0.3)
		}
	}

	@objc private func testButtonPressed() {
		delegate?.testButtonPressed()
	}
	
	@objc private func logOffButtonPressed() {
		delegate?.logOffButtonPressed()
	}
	
	override func updateHeight() {
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height - 64)
	}
}
