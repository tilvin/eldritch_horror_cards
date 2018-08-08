//
//  MenuView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 7/27/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol MenuViewDelegate: class {
	func backgroundTap()
}

class MenuView: UIView {
	weak var delegate: MenuViewDelegate?
	private var viewModel: MenuViewModel!
	
	fileprivate(set) lazy var contentView: MenuContentView = {
		return MenuContentView()
	}()

	//MARK: - Lifecycle
	convenience init(frame: CGRect = CGRect.zero, viewModel: MenuViewModel) {
		self.init(frame: frame)
		self.viewModel = viewModel
		
		backgroundColor = UIColor.black.withAlphaComponent(0.8)
		addSubviews()
		makeConstraints()
		let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
		addGestureRecognizer(gesture)
		contentView.update(name: viewModel.userName, avatar: viewModel.avatar)
		layoutIfNeeded()		
	}
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	public func update(viewModel: MenuViewModel) {
		self.viewModel = viewModel
		contentView.update(name: viewModel.userName, avatar: viewModel.avatar)
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(contentView)
	}
	
	private func makeConstraints() {
		contentView.snp.makeConstraints { (make) in
			make.left.top.bottom.equalToSuperview()
			make.width.equalToSuperview().multipliedBy(0.8)
		}
	}
	
	@objc private func backgroundTap() {
		delegate?.backgroundTap()
	}
}
