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
		gameProvider.loadGameId { [unowned self] (success) in
			guard success else {
				self.showErrorAlert(message: String(.gameInitError))
				return
			}
			self.additionProvider.load { (additions) in
				self.view.hideProccessing()
				self.adapter.configure(with: additions)
			}
		}
	}
}

extension AdditionsViewController: AdditionsListTableAdapterDelegate {
	
	func didTapInfo(with model: Addition) {
		let controller = DescriptionViewController(with: Description.init(name: model.name, description: model.description))
		appNavigator?.go(controller: controller, mode: .push)
	}
	
	func update(with model: Addition) {
		guard let item = additionProvider.additions.enumerated().filter({ (_, item) -> Bool in
			return item.id == model.id
		}).first else { return }
		additionProvider.additions[item.offset] = model
	}
}

extension AdditionsViewController: MenuEmbedProtocol {}

extension AdditionsViewController: AdditionsListViewDelegate {
	
	func menuButtonAction() {
		let reloadCmd = Command {  (_) in
			print("reload view!")
		}
		menuAction?.perform(with: reloadCmd)
	}
	
	func continueButtonAction() {
		let provider = DI.providers.resolve(AdditionDataProviderProtocol.self)!
		let additions = provider.additions.filter { $0.isSelected}.map { String($0.id)}
		let maps = provider.additions.filter { $0.isSelectedMap }.map { String($0.id)}
		
		provider.selectAdditions(gameId: gameProvider.game.id, additions: additions, maps: maps) { [weak self] (success) in
            guard let sSelf = self else { return }
			
            if !success {
                sSelf.showErrorAlert(message: String(.additionContinueButtonError))
                return
            }
            let controller = MainViewController()
            controller.modalTransitionStyle = .crossDissolve
            sSelf.appNavigator?.go(controller: controller, mode: .modal)
		}
	}
}
