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
	func turnsHistoryPressed()
	func expeditionCurrentLocationPressed()
	func logoutButtonPressed()
}

extension MenuContentView {
	
	struct Appearance {
		let avatarTopSeparator: CGFloat = 50
		let defaultSeparator: CGFloat = 10
		let avatarBottomSeparator: CGFloat = 15
		let logoutBottomSeparator: CGFloat = 34
		let avatarWidthHeight: CGFloat = 100
		let widthMultipliedBy: CGFloat = 0.9
		let separatorLineViewHeight: CGFloat = 1
		let buttonHeight: CGFloat = 24
		let buttonLeadingOffset: CGFloat = 32
		let scrollViewBottom: CGFloat = 64
	}
}

class MenuContentView: BaseScrollView {
	weak var delegate: MenuContentViewProtocol?
	private let appearance = Appearance()
	
	public func update(name: String, avatar: UIImage?) {
		avatarView.update(avatar: avatar)
		userName.text = name
	}
	
	//MARK: -
	
	private lazy var avatarView: AvatarView = {
		return AvatarView()
	}()
	
	private lazy var userName: UILabel = {
		let view = UILabel(font: .bold28, textColor: .wildSand)
		view.textAlignment = .center
		view.numberOfLines = 0
		view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
		return view
	}()
	
	private lazy var separatorLineView: UIView = {
		return UIView(backgroundColor: .wildSand)
	}()
	
	private lazy var turnsHistoryButton: UIButton = {
		let view = UIButton()
		view.setTitle(String(.turnHistory), for: .normal)
		view.contentHorizontalAlignment = .left
		view.setTitleColor(.wildSand, for: .normal)
		view.addTarget(self, action: #selector(turnsHistoryButtonPressed), for: .touchUpInside)
		return view
	}()
	
	private lazy var expeditionCurrentLocationButton: UIButton = {
		let view = UIButton()
		view.setTitle(String(.expeditionCurrentLocation), for: .normal)
		view.contentHorizontalAlignment = .left
		view.setTitleColor(.wildSand, for: .normal)
		view.addTarget(self, action: #selector(expeditionCurrentLocationButtonPressed), for: .touchUpInside)
		return view
	}()
	
	private lazy var logoutButton: UIButton = {
		let view = UIButton()
		view.setTitle(String(.logout), for: .normal)
		view.titleLabel?.textAlignment = .left
		view.setTitleColor(.wildSand, for: .normal)
		view.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
		return view
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		scrollView.backgroundColor =  UIColor.viridianTwo.withAlphaComponent(0.95)
		addSubviews()
		makeConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSeparatorView(height: appearance.avatarTopSeparator)
		addToStackView(view: avatarView, embed: true)
		addSeparatorView(height: appearance.avatarBottomSeparator)
		addToStackView(view: userName, embed: true)
		addSeparatorView(height: appearance.defaultSeparator)
		addToStackView(view: separatorLineView, embed: true)
		addSeparatorView(height: appearance.defaultSeparator)
		addToStackView(view: turnsHistoryButton, embed: true)
		addSeparatorView(height: appearance.defaultSeparator)
		addToStackView(view: expeditionCurrentLocationButton, embed: true)
//		addSeparatorView(height: appearance.defaultSeparator)
//		addToStackView(view: logoutButton, embed: true)
		addSeparatorView(height: appearance.logoutBottomSeparator)
	}
	
	private func makeConstraints() {
		avatarView.snp.makeConstraints { (make) in
			make.width.height.equalTo(appearance.avatarWidthHeight)
			make.top.bottom.equalToSuperview()
			make.centerX.equalToSuperview()
		}
		
		userName.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(appearance.widthMultipliedBy)
			make.top.bottom.equalToSuperview()
			make.centerX.equalToSuperview()
		}
		
		separatorLineView.snp.makeConstraints { (make) in
			make.width.equalToSuperview().multipliedBy(appearance.widthMultipliedBy)
			make.height.equalTo(appearance.separatorLineViewHeight)
			make.top.bottom.equalToSuperview()
			make.centerX.equalToSuperview()
		}
		
		turnsHistoryButton.snp.makeConstraints { make in
			make.height.equalTo(appearance.buttonHeight)
			make.top.bottom.equalToSuperview()
			make.width.equalToSuperview()
			make.leading.equalToSuperview().offset(appearance.buttonLeadingOffset)
		}
		
		expeditionCurrentLocationButton.snp.makeConstraints { make in
			make.height.equalTo(appearance.buttonHeight)
			make.top.bottom.equalToSuperview()
			make.width.equalToSuperview()
			make.leading.equalToSuperview().offset(appearance.buttonLeadingOffset)
		}
	}
	
	@objc private func turnsHistoryButtonPressed() {
		delegate?.turnsHistoryPressed()
	}
	
	@objc private func expeditionCurrentLocationButtonPressed() {
		delegate?.expeditionCurrentLocationPressed()
	}
	
	@objc private func logoutButtonPressed() {
		delegate?.logoutButtonPressed()
	}
	
	override func updateHeight() {
		scrollView.contentSize = CGSize(width: scrollView.frame.width, height: stackView.frame.height - appearance.scrollViewBottom)
	}
}
