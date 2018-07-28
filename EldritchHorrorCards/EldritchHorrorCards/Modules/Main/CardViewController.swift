//
//  CardViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 27.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//
import UIKit

class  CardViewController: CardsCarousel {
    
    private var cardsTypeProvider = DI.providers.resolve(CardsTypeDataProtocol.self)!
    private var cardsType: [CardsType] = []
    var arrayImage = [UIImage.artifact, UIImage.asset, UIImage.contact, UIImage.contactAsiaAustralia]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        cardsTypeProvider.load()
        cardsType = cardsTypeProvider.cardShirt
        viewConfigrations()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCellsLayout()
    }
    
}
extension CardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsType.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.cardImageView.image = cardsType[indexPath.row].image
        cell.cardTypeLabel.text = cardsType[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width -= collectionView.contentInset.left * 2
        cellSize.width -= collectionView.contentInset.right * 2
        
        return cellSize
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCellsLayout()
        
    }
}
