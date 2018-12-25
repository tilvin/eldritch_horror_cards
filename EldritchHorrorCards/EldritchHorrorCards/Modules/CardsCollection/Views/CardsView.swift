//
//  CartView.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 11/11/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

protocol CardsViewDelegate: class {
	func closeButtonPressed()
}

extension CardsView {
	
	struct Appearance {
		let closeTopOffset: CGFloat = 30
		let closeRightOffset: CGFloat = 10
		let closeSizeWH: CGFloat = 25
		let collectionViewTopOffset: CGFloat = 80
          let itemSizeIndex: CGFloat = 0.6
	}
}

final class CardsView: UIView {
	weak var delegate: CardsViewDelegate?
	private let appearance = Appearance()
	
	//MARK: - Lazy variables
	
	private lazy var closeButton: CustomButton = {
		let view = CustomButton(type: .close)
		view.setImage(UIImage.closeButton, for: .normal)
		view.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
		return view
	}()
	
	lazy var cartCollectionView: UICollectionView = {
		let layout = UPCarouselFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sideItemAlpha = 0.6
		layout.sideItemScale = 0.8
		layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * appearance.itemSizeIndex, height: UIScreen.main.bounds.height * appearance.itemSizeIndex)
		let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
		view.backgroundColor = UIColor.wildSand
		view.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
		view.decelerationRate = UIScrollViewDecelerationRateFast
		return view
	}()
	
	//MARK: - Init
	
	override init(frame: CGRect = CGRect.zero) {
		super.init(frame: frame)
		backgroundColor = UIColor.wildSand
		addSubviews()
		makeContraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("required init!")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(closeButton)
		addSubview(cartCollectionView)
	}
	
	private func makeContraints() {
		closeButton.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(appearance.closeTopOffset)
			make.right.equalToSuperview().inset(appearance.closeRightOffset)
			make.width.height.equalTo(appearance.closeSizeWH)
		}
		
		cartCollectionView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalToSuperview().inset(appearance.collectionViewTopOffset)
			make.centerY.equalToSuperview()
		}
	}
	
	//MARK: - Handlers
	
	@objc
	private func closeButtonPressed() {
		delegate?.closeButtonPressed()
	}
}
