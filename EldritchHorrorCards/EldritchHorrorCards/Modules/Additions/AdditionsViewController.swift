import UIKit

final class AdditionsViewController: BaseViewController {
	
	var customView: AdditionsListView { return self.view as! AdditionsListView }
	var adapter = AdditionsListTableAdapter()
	var menuAction: CommandWith<Command>!
	var menuContainerView: UIView { return customView.menuContainer }
	
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	private let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
	private var additionProvider = DI.providers.resolve(AdditionDataProviderProtocol.self)!
	
	// MARK: - View lifecycle
	
	override func loadView() {
		self.view = AdditionsListView(frame: UIScreen.main.bounds)
		adapter.delegate = self
		adapter.load(tableView: customView.tableView)
		isHiddenNavigationBar = true
		customView.delegate = self
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupMenu()
		view.showProccessing()
		
		gameProvider.loadGame() { [unowned self] (result) in
			self.view.hideProccessing()
			switch result {
			case .failure(let error):
				self.showErrorAlert(message: error.message)
			case .success:
				guard self.gameProvider.game.isNewGame else {
					self.appNavigator?.go(controller: CardsViewController(), mode: .push, animated: true)
					return
				}
				self.additionProvider.load(completion: { (result) in
					switch result {
					case .success(let additions):
						self.additionProvider.additions = additions
						self.adapter.configure(with: additions)
					case .failure(let error):
						self.showErrorAlert(message: error.message)
					}
				})
			}
		}
	}
}

extension AdditionsViewController: AdditionsListTableAdapterDelegate {
	
	func didTapInfo(with model: AdditionModel) {
		let controller = DescriptionViewController(with: Description.init(name: model.name, description: model.description))
		appNavigator?.go(controller: controller, mode: .push)
	}
	
	func update(with model: AdditionModel) {
		guard let item = additionProvider.additions.enumerated().filter({ (_, item) -> Bool in
			return item.id == model.id
		}).first else { return }
		additionProvider.additions[item.offset] = model
	}
}

extension AdditionsViewController: MenuEmbedProtocol {}

extension AdditionsViewController: AdditionsListViewDelegate {
	
	func menuButtonPressed() {
		let reloadCmd = Command {  (_) in
			print("reload view!")
		}
		menuAction?.perform(with: reloadCmd)
	}
	
	func continueButtonPressed() {
		
//		appNavigator?.go(controller: AuthViewController(), mode: .push, animated: true)
		let provider = DI.providers.resolve(AdditionDataProviderProtocol.self)!
		let additions = provider.additions.filter { $0.isSelected}.map { String($0.id)}
		let maps = provider.additions.filter { $0.isSelectedMap }.map { String($0.id)}

		provider.selectAdditions(gameId: gameProvider.game.id, additions: additions, maps: maps) { [weak self] (result) in
			guard let sSelf = self else { return }

			switch result {
			case .success:
				let controller = MainViewController()
				controller.modalTransitionStyle = .crossDissolve
				sSelf.appNavigator?.go(controller: controller, mode: .modal)
			case .failure(let error):
				sSelf.showErrorAlert(message: error.message)
			}
		}
	}
}
