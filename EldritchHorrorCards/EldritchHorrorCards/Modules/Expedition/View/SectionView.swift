//
//  SectionView.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 18/11/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension SectionView {
	
	struct Appearance {
		let defaultSideOffset: CGFloat = 25
		let markViewDefault: CGFloat = 8
		let textViewRight: CGFloat = ScreenType.item(for: (.inch4, 0), (.inch5_5, 24))
		let textViewTopBottom: CGFloat = ScreenType.item(for: (.inch4, 0), (.inch5_5, 16))
	}
}

final class SectionView: UIView {
	
	//MARK: - Private variables
	
	private let appearance = Appearance()
	
	//MARK: - Private lazy variables
	
	private lazy var markView: UIView = {
		let view = UIView()
		view.backgroundColor = .whiteTwo
		view.layer.cornerRadius = 4
		view.clipsToBounds = true
		return view
	}()
	
	private lazy var textView: UITextView = {
		let view = UITextView()
		view.isEditable = false
		view.textColor = .mako
		view.backgroundColor = .clear
		view.textAlignment = .left
		view.font = .regular14
		return view
	}()
	
	//MARK: - Init
	
	init(viewModel: SectionViewModel) {
		super.init(frame: .zero)
		backgroundColor = viewModel.color
		textView.text = viewModel.text
		clipsToBounds = true
		layer.cornerRadius = 8
		addSubviews()
		makeConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Public
	
	public func update(viewModel: SectionViewModel) {
		textView.text = viewModel.text
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(markView)
		addSubview(textView)
	}
	
	private func makeConstraints() {
		
		markView.snp.makeConstraints { (make) in
			make.width.height.equalTo(appearance.markViewDefault)
			make.left.top.equalToSuperview().inset(appearance.markViewDefault)
		}
		
		textView.snp.remakeConstraints { (make) in
			make.left.equalToSuperview().inset(appearance.defaultSideOffset)
			make.right.equalToSuperview().inset(appearance.textViewRight)
			make.top.bottom.equalToSuperview().inset(appearance.textViewTopBottom)
		}
	}
}
