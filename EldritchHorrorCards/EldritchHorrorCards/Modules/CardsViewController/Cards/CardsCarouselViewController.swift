//
//  CardsCarousel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 28.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class CardsCarouselViewController: BaseViewController {
	@IBOutlet private var collectionView: UICollectionView!
	
	//MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.wildSand
	}
	
	func viewConfigrations() {
		collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
		collectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
		collectionView.decelerationRate = UIScrollViewDecelerationRateFast
		collectionView.backgroundColor = view.backgroundColor
		let layout = UPCarouselFlowLayout()
		layout.scrollDirection = .horizontal
		layout.sideItemAlpha = 0.6
		layout.sideItemScale = 0.8
		layout.spacingMode = UPCarouselFlowLayoutSpacingMode.fixed(spacing: 10)
		collectionView?.setCollectionViewLayout(layout, animated: false)
	}
}

