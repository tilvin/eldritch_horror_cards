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
    private var adapter = CardsCollectionAdapter()
    private var provider = DI.providers.resolve(CardsCollectionDataProviderProtocol.self)!
	private let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
	private let cardDataProvider = DI.providers.resolve(CardDataProviderProtocol.self)!
	
	//MARK: - Init
	
	init() {
		super.init(nibName: nil, bundle: nil)
		isHiddenNavigationBar = true
		hidesBottomBarWhenPushed = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = CardsView(frame: UIScreen.main.bounds)
		customView.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if provider.cards.count == 0 {
			provider.load() { [weak self] (success) in
				guard let sSelf = self else { return }
				guard success else {
					sSelf.showErrorAlert(message: String(.cantLoadCards))
					return
				}
				sSelf.updateViewModel()
			}
			return
		}
		updateViewModel()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		adapter.load(collectionView: customView.cartCollectionView, delegate: self)
	}
	
	private func updateViewModel() {
		let viewModel = provider.cards.map({ (card) -> CardCellViewModel in
			return CardCellViewModel.init(title: card.type.rawValue, image: UIImage(named: card.type.rawValue))
		})
		adapter.configure(with: viewModel)
	}
	
	private func updateCards() {
		provider.updateCards(isUseOnlyRealm: true) { [weak self] (_) in
			guard let sSelf = self else { return }
			sSelf.updateViewModel()
		}
	}
}

extension CardsViewController: CardsViewDelegate {
	
	func closeButtonPressed() {
		let alert = Alert(title: String(.warning), message: String(.gameOverAlert), preferredStyle: .alert)
		alert.addAction(title: String(.ok), style: .default) { [weak self] (_) in
			let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
			gameProvider.removeGame()
			
			let additionVC = AdditionsViewController()
			additionVC.modalTransitionStyle = .crossDissolve
			self?.appNavigator?.go(controller: additionVC, mode: .replace)
		}
		alert.addAction(title: String(.cancel), style: .cancel)
		alert.present(in: self)
	}
}

extension CardsViewController: CardsCollectionAdapterDelegate {
    
    func cardSelected(type: CardType) {
		cardDataProvider.get(gameId: gameProvider.game.id, type: type) { [weak self] (result) in
			guard let sSelf = self else { return }

			switch result {
			case let .localStory(model):
				let controller = LocalStoryViewController(model: model)
				controller.modalTransitionStyle = .crossDissolve
				sSelf.appNavigator?.go(controller: controller, mode: .push)
			case let .plotStory(model):
				if type.isExpedition,
					let nextExpedition = model.nextLocation {
					sSelf.gameProvider.setNextExpedition(location: nextExpedition) {
						sSelf.updateCards()
					}
				}
				let controller = PlotStoryController(model: model, type: type.rawValue)
				controller.modalTransitionStyle = .crossDissolve
				sSelf.appNavigator?.go(controller: controller, mode: .push)
			case let .failure(error):
				sSelf.showErrorAlert(message: error.message)
			}
		}
    }
}
