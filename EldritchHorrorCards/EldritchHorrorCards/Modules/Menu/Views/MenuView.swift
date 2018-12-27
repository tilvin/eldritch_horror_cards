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
	func turnsHistoryButtonTap()
	func expeditionCurrentLocationButtonTap()
	func logoutButtonTap()
}

extension MenuView {
	
	struct Appearance {
		let widthMultiply: CGFloat = 0.8
	}
}

class MenuView: UIView {
	weak var delegate: MenuViewDelegate?
	private var viewModel: MenuViewModel!
	private let appearance = Appearance()
	
	fileprivate(set) lazy var contentView: MenuContentView = {
		return MenuContentView()
	}()
	
	//MARK: - Lifecycle
	
	init(frame: CGRect = CGRect.zero, viewModel: MenuViewModel) {
		super.init(frame: frame)
		self.viewModel = viewModel
		addSubviews()
		makeConstraints()
		let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
		addGestureRecognizer(gesture)
		contentView.update(name: viewModel.userName, avatar: viewModel.avatar)
		layoutIfNeeded()
		contentView.delegate = self
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
			make.width.equalToSuperview().multipliedBy(appearance.widthMultiply)
		}
	}
	
	@objc private func backgroundTap() {
		delegate?.backgroundTap()
	}	
}

//MARK: - MenuContentViewProtocol

extension MenuView: MenuContentViewProtocol {
	
	func turnsHistoryPressed() {
		delegate?.turnsHistoryButtonTap()
	}
	
	func expeditionCurrentLocationPressed() {
		delegate?.expeditionCurrentLocationButtonTap()
	}
	
	func logoutButtonPressed() {
		delegate?.logoutButtonTap()
	}
}
