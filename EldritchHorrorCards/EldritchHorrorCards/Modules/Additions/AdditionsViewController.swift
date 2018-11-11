import UIKit

class AdditionsViewController: BaseViewController {

	var customView: AdditionsListView { return self.view as! AdditionsListView }
	var adapter = AdditionsListTableAdapter()
	var menuAction: CommandWith<Command>!
	var menuContainerView: UIView { return customView.menuContainer }
	private let userDefaultsProvider = DI.providers.resolve(UserDefaultsDataStoreProtocol.self)!
	
	// MARK: - View lifecycle
	
	override func loadView() {
		self.view = AdditionsListView(frame: UIScreen.main.bounds)
		adapter.delegate = self
		adapter.load(tableView: customView.tableView)
		isHiddenNavigationBar = true
		setupMenu()
		customView.delegate = self
	}	
}

extension AdditionsViewController: AdditionsListTableAdapterDelegate {
	
	func didTapInfo(with model: Addition) {
		let controller = DescriptionViewController(with: Description.init(name: model.name, description: model.description))
		appNavigator?.go(controller: controller, mode: .push)
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
		let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
		let monsterProvider = DI.providers.resolve(MonsterDataProviderProtocol.self)!
		let additions = provider.additions.filter { $0.isSelected}.map { String($0.id)}
		let maps = provider.additions.filter { $0.isSelectedMap }.map { String($0.id)}
		
		provider.selectAdditions(gameId: gameProvider.game.id, additions: additions, maps: maps) { [weak self] (success) in
			guard let sSelf = self else { return }
			if success {
				print("Additions sent...")
				monsterProvider.load(gameId: gameProvider.game.id) { (success) in
					if success {
						print("Monster is load!")
						let controller = MainViewController()
						controller.modalTransitionStyle = .crossDissolve
						sSelf.appNavigator?.go(controller: controller, mode: .modal)
					}
					else {
						//TODO: Алерт и переход к авторизации или выбору дополнений (как договоримся)
						print("error! Something gone wrong!")
					}
				}
			}
			else {
				//TODO: Алерт и переход к авторизации или выбору дополнений (как договоримся)
				print("error!")
			}
		}
	}
}
