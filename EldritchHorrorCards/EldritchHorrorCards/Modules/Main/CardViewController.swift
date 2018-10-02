//
//  CardViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 27.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import UIKit

class CardViewController: CardsCarousel {
    var cardsTypes: [CardType] = CardType.all
    
    let cardType = CardType.self
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.wildSand
		isHiddenNavigationBar = true
		viewConfigrations()
	}
}

extension CardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return cardsTypes.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
		if (indexPath.row == 0) {
			collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
		}
		cell.cardImageView.image = cardsTypes[indexPath.row].image
		cell.cardTypeLabel.text = cardsTypes[indexPath.row].title
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var cellSize: CGSize = collectionView.bounds.size
		cellSize.width -= collectionView.contentInset.left * 2
		cellSize.width -= collectionView.contentInset.right * 2
		return cellSize
	}
}

extension CardViewController {

	enum CardType: String {
		case portals = "Portals"
		case cities = "Cities"
		case expeditions = "Expeditions"
		case contacts = "Contacts"
		case evidences = "Evidences"
		case specialContacts = "Special Contacts"

		static var all: [CardType] {
			return [CardType.portals,
					CardType.cities,
					CardType.expeditions,
					CardType.contacts,
					CardType.evidences,
					CardType.specialContacts]
		}

		var title: String {
			return self.rawValue
		}

		var image: UIImage {
			switch self {
			case .portals: return UIImage.portal
			case .cities: return UIImage.asset
			case .expeditions: return UIImage.expeditionAfrica
			case .contacts: return UIImage.contact
			case .evidences: return UIImage.asset
			case .specialContacts: return UIImage.specialContactCthulhu
			}
		}
	}
}
