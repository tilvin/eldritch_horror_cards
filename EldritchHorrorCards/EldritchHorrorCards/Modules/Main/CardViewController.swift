//
//  CardViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 27.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import UIKit

class CardViewController: CardsCarousel {
	
	//MARK: - Private variables
	
	private var cardProvider = DI.providers.resolve(CardDataProviderProtocol.self)!
	private var cards: Cards?
	
	//MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.wildSand
		isHiddenNavigationBar = true
		viewConfigrations()
		cards = cardProvider.cards
	}
}

extension CardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cards!.avaliableCardTypes.first!.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
		if (indexPath.row == 0) {
			collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
		}
		cell.cardImageView.image = UIImage(named: cards!.avaliableCardTypes.first![indexPath.row])
		cell.cardTypeLabel.text = cards!.avaliableCardTypes.first![indexPath.row].localized
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var cellSize: CGSize = collectionView.bounds.size
		cellSize.width -= collectionView.contentInset.left * 2
		cellSize.width -= collectionView.contentInset.right * 2
		return cellSize
	}
}
