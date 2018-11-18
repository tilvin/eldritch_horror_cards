//
//  CardsCarousel.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 28.07.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class CardsViewController: BaseViewController {
	
	private var customView: CardsView { return view as! CardsView }
    private var provider = DI.providers.resolve(CardDataProviderProtocol.self)!
    private var adapter = CardsCollectionAdapter()
    
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
		customView.delegate = self
        adapter.load(collectionView: customView.cartCollectionView, delegate: self)
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

extension CardsViewController: CardsCollectionAdapterDelegate {
    
    func cardSelected(type: String) {
        var provider = DI.providers.resolve(ExpeditionDataProviderProtocol.self)!
        let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
        provider.expeditionType = type
        provider.load(gameId: gameProvider.game.id, type: type) { [weak self] (success) in
            guard let sSelf = self else { return }
            if success {
                let controller = ExpeditionViewController()
                controller.modalTransitionStyle = .crossDissolve
                sSelf.appNavigator?.go(controller: controller, mode: .push)
            }
            else {
                print("error!")
            }
        }
    }
}