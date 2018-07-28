//
//  CardsCarousel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 28.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class CardsCarousel: BaseViewController {
	@IBOutlet private var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.wildSand
	}
	
	func viewConfigrations() {
		collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
		collectionView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30)
		collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.backgroundColor = UIColor.scorpion 
	}
    
	func updateCellsLayout()  {
		let centerX = collectionView.contentOffset.x + (collectionView.frame.size.width) / 2
		for cell in collectionView.visibleCells {
			var offsetX = centerX - cell.center.x
			if offsetX < 0 { offsetX *= -1 }
			cell.transform = CGAffineTransform.identity
			let offsetPercentage = offsetX / (view.bounds.width * 2.7)
			let scaleX = 1-offsetPercentage
			cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX * 1.2)
		}
	}
}

