//
//  AdditionsView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 8/19/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

protocol AdditionsViewDelegate: class {

}

class AdditionsView: UIView {
	weak var delegate: AdditionsViewDelegate?
	private var viewModel: AdditionsViewModel!
	
	fileprivate(set) lazy var contentView: MenuContentView = {
		return MenuContentView()
	}()
	
	//MARK: - Lifecycle
	convenience init(frame: CGRect = CGRect.zero, viewModel: AdditionsViewModel) {
		self.init(frame: frame)
		self.viewModel = viewModel
//		backgroundColor = UIColor.black.withAlphaComponent(0.8)
		addSubviews()
		makeConstraints()
		layoutIfNeeded()
	}
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	public func update(viewModel: AdditionsViewModel) {
		self.viewModel = viewModel
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(contentView)
	}
	
	private func makeConstraints() {
		
	}
}
