//
//  MonsterDescriptionView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/31/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol MonsterDescriptionViewDelegate: class {
	func closeButtonPressed()
}

class MonsterDescriptionView: UIView {
	var monsterDescription: String?
	weak var delegate: MonsterDescriptionViewDelegate?
	
	//MARK: -
	
	private lazy var descriptionTextView: UITextView = {
		let tv = UITextView()
		tv.font = UIFont.regular14
		tv.textColor = UIColor.darkGray
		tv.text = monsterDescription
		return tv
	}()
	
	
	private lazy var closeButtonView: CloseButtonView = {
		return CloseButtonView()
	}()
	
	//MARK: - Lifecycle
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor = UIColor.wildSand
		addSubviews()
		makeConstraints()
		closeButtonView.closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(descriptionTextView)
		addSubview(closeButtonView)
	}
	
	private func makeConstraints() {
		descriptionTextView.snp.makeConstraints { (make) in
			make.left.right.bottom.equalToSuperview().inset(10)
			make.top.equalToSuperview().inset(60)
		}
		
		closeButtonView.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(30)
			make.right.equalToSuperview().inset(10)
			make.width.height.equalTo(25)
		}
	}
	
	@objc private func closeButtonTap() {
		delegate?.closeButtonPressed()
	}
}
