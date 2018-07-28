//
//  AvatarView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/28/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

class AvatarView: DesignableView {
	
	private lazy var avatarContentView: DesignableView = {
		let view = DesignableView()
		view.backgroundColor = .white
		view.borderColor = UIColor.wildSand
		view.borderWidth = 5
		view.computeCornerRadius = true
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var defaultAvatar: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage.defaultAvatar
		return imageView
	}()
	
	private lazy var userAvatar: UIImageView = {
		let imageView = UIImageView()
		return imageView
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		userAvatar.isHidden = true
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
		let isShow = avatar != nil
		if userAvatar.isHidden != !isShow {
			userAvatar.image = avatar
			if isShow { userAvatar.isHidden = false }
			userAvatar.alpha = isShow ? 0 : 1
			
			UIView.animate(withDuration: 1,
						   animations: {
							self.userAvatar.alpha = isShow ? 1 : 0
			}) { (success) in
				self.userAvatar.isHidden = !isShow
			}
		}
	}
	
	//MARK: - Private
	
	private func setAppearence() {
		backgroundColor = UIColor.wildSand
		computeCornerRadius = true
		shadowOpacity = 1
		shadowRadius = 4
		shadowOffset = CGPoint(x: 0, y: 0)
		shadowColor = .black
	}
	
	private func addSubviews() {
		avatarContentView.addSubview(defaultAvatar)
		avatarContentView.addSubview(userAvatar)
		addSubview(avatarContentView)
	}
	
	private func makeConstraints() {
		avatarContentView.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		defaultAvatar.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		userAvatar.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}
