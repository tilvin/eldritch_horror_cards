//
//  CardsCollectionAdapter.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 11/15/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

extension CardsCollectionAdapter {
    
    private struct Appearance {
        let emptyViewTopOffset: CGFloat = 24
    }
}

protocol CardsCollectionAdapterDelegate: class {
    func cardSelected(type: CardType)
}

class CardsCollectionAdapter: BaseCollectionAdapter {
    private weak var delegate: CardsCollectionAdapterDelegate?
    private var viewModel: [CardCellViewModel] = []
    private var cardProvider = DI.providers.resolve(CardDataProviderProtocol.self)!
    private var appearance = Appearance()
    
    func load(collectionView: UICollectionView, delegate: CardsCollectionAdapterDelegate?) {
        connect(collectionView: collectionView)
        self.delegate = delegate
    }
	
   override func connect(collectionView: UICollectionView) {
        super.connect(collectionView: collectionView)
        collectionView.contentSize = UICollectionViewFlowLayoutAutomaticSize
        registerCell(items: [ImageCell.identifier: ImageCell.self])
    }
	
    func configure(with models: [CardCellViewModel]) {
        viewModel = models
        collectionView?.reloadData()
        
        if models.isEmpty {
            collectionView?.showEmptyView(title: String(.empty), at: .top(offset: appearance.emptyViewTopOffset))
        }
        else {
            collectionView?.hideEmptyView()
        }
    }
    
    // MARK: - DataSource and Delegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func cellIdentifier(for indexPath: IndexPath) -> String {
        return ImageCell.identifier
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = cellIdentifier(for: indexPath)
        guard let cell = cellBy(identifier: identifier, indexPath: indexPath) as? ImageCell else {
            return BaseCollectionViewCell()
        }
        cell.update(with: viewModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard indexPath.row < viewModel.count else { return }
		guard let cardType = CardType(rawValue: viewModel[indexPath.row].title) else { return }
        delegate?.cardSelected(type: cardType)
    }
}
