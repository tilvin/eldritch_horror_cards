//
//  CardsCarousel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 28.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class CardsViewController: BaseViewController {
	
	public var customView: CardsView { return view as! CardsView }
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
		view = CardsView(frame: UIScreen.main.bounds)
		customView.cartCollectionView.delegate = self
		customView.cartCollectionView.dataSource = self
		customView.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		cards = cardProvider.cards
	}
}

extension CardsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
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

extension CardsViewController: CardsViewDelegate {
	
	func closeButtonPressed() {
		let alert = Alert(title: String(.warning), message: String(.gameOverAlert), preferredStyle: .alert)
		alert.addAction(title: String(.ok), style: .default) { [weak self] (_) in
			let additionVC = AdditionsViewController()
			additionVC.modalTransitionStyle = .crossDissolve
			self?.appNavigator?.go(controller: additionVC, mode: .replace)
		}
		alert.addAction(title: String(.cancel), style: .cancel)
		alert.present(in: self)
	}
}
