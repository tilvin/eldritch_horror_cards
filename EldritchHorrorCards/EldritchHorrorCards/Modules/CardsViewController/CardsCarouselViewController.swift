//
//  CardsCarousel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 28.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class CardsCarouselViewController: BaseViewController {
	
	public var customView: CartView { return view as! CartView }
	private var cardProvider = DI.providers.resolve(CardDataProviderProtocol.self)!
	private var cards: Cards?
	
	//MARK: - Init
	
	init() {
		super.init(nibName: nil, bundle: nil)
		self.isHiddenNavigationBar = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = CartView(frame: UIScreen.main.bounds)
		customView.cartCollectionView.delegate = self
		customView.cartCollectionView.dataSource = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		cards = cardProvider.cards
	}
}

extension CardsCarouselViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cards!.avaliableCardTypes.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
		if (indexPath.row == 0) {
			collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
		}
		cell.cardImageView.image = UIImage(named: cards!.avaliableCardTypes[indexPath.row])
		cell.cardTypeLabel.text = cards!.avaliableCardTypes[indexPath.row].localized
		cell.cardType = cards!.avaliableCardTypes[indexPath.row]
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var cellSize: CGSize = collectionView.bounds.size
		cellSize.width -= collectionView.contentInset.left * 2
		cellSize.width -= collectionView.contentInset.right * 2
		return cellSize
	}
}
