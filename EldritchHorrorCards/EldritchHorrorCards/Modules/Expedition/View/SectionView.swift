//
//  SectionView.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 18/11/2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit
import SnapKit

extension SectionView {
	struct Appearance {
		let defaultSideOffset: CGFloat = 25
		let markViewDefault: CGFloat = 8
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
	
	//MARK: - Init
	init(viewColor: UIColor) {
		super.init(frame: .zero)
		self.backgroundColor = viewColor
		self.clipsToBounds = true
		self.layer.cornerRadius = 8
		self.addSubview(markView)
		makeConstraints()
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	private func makeConstraints() {
		markView.snp.makeConstraints { (make) in
			make.width.height.equalTo(appearance.markViewDefault)
			make.left.top.equalToSuperview().inset(appearance.markViewDefault)
		}
	}
}
