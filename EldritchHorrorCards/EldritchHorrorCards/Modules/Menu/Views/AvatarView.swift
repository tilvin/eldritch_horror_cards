//
//  AvatarView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

extension AvatarView {
	
	struct Appearance {
		let borderWidth: CGFloat = 5
		let shadowOpacity: CGFloat = 1
		let shadowRadius: CGFloat = 4
		let shadowOffset = CGPoint(x: 0, y: 0)
	}
}

class AvatarView: DesignableView {
	
	private let appearance = Appearance()
	
	private lazy var avatarContentView: DesignableView = {
		let view = DesignableView()
		view.backgroundColor = .white
		view.borderColor = UIColor.wildSand
		view.borderWidth = appearance.borderWidth
		view.computeCornerRadius = true
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var userAvatar: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage.defaultAvatar
		return imageView
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		setAppearence()
		addSubviews()
		makeConstraints()
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	func update(avatar: UIImage?) {
		let image = avatar ?? UIImage.defaultAvatar
		DispatchQueue.main.async {
			self.userAvatar.set(image: image)
		}
	}
	
	//MARK: - Private
	
	private func setAppearence() {
		backgroundColor = UIColor.wildSand
		computeCornerRadius = true
		shadowOpacity = appearance.shadowOpacity
		shadowRadius = appearance.shadowRadius
		shadowOffset = appearance.shadowOffset
		shadowColor = .black
	}
	
	private func addSubviews() {
		avatarContentView.addSubview(userAvatar)
		addSubview(avatarContentView)
	}
	
	private func makeConstraints() {
		avatarContentView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		userAvatar.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}
