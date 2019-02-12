//
//  SectionView.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 18/11/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension CardSectionView {
	
	struct Appearance {
		let defaultSideOffset: CGFloat = 25
		let markViewDefault: CGFloat = 8
		let textViewRight: CGFloat = ScreenType.item(for: (.inch4, 10), (.inch5_5, 25))
		let textViewTopBottom: CGFloat = ScreenType.item(for: (.inch4, 10), (.inch5_5, 20))
	}
}

final class CardSectionView: UIView {
	
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
		let view = UITextView(backgroundColor: .clear)
		view.isEditable = false
		view.textAlignment = .left
		view.font = .regular14
		return view
	}()
	
	//MARK: - Init
	
	init(viewModel: CardSectionViewModel? = nil) {
		super.init(frame: .zero)
		let localVieModel = viewModel ?? CardSectionViewModel()
		textView.isSelectable = localVieModel.isSelectable
		update(viewModel: localVieModel)
		addSubviews()
		makeConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		cornerRadius = 8
		clipsToBounds = true
	}
	
	//MARK: - Public
	
	public func update(viewModel: CardSectionViewModel) {
        backgroundColor = viewModel.backgroundColor
        textView.text = viewModel.text
        textView.textColor = viewModel.textColor
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
