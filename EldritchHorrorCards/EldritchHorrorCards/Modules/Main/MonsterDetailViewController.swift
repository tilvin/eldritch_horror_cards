import UIKit

class MonsterDetailViewController: BaseViewController {
	var monster: Monster!
	
	@IBOutlet private var bgImageView: UIImageView!
	@IBOutlet private var nameLabel: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		isHiddenNavigationBar = true
		guard let _item = monster else { fatalError("No user to display.") }
		bgImageView.image = UIImage(named: monster.imageURLString)
		nameLabel.text = "\(_item.name) (\(_item.score))"
	}
	
	@IBAction func callMonsterAction(_ sender: AnyObject) {
		let provider = DI.providers.resolve(MonsterDataProviderProtocol.self)!
		let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
		
		provider.selectAncient(gameId: gameProvider.game.id, ancient: monster) { [weak self] (success) in
			guard let sSelf = self else { return }
			guard success else {
				sSelf.showErrorAlert(message: String(.cantSelectAncient))
				return
			}
			let controller = CardsViewController()
			controller.modalTransitionStyle = .crossDissolve
			sSelf.appNavigator?.go(controller: controller, mode: .modal)
		}
	}
	
	@IBAction private func infoAboutMonster(_ sender: Any) {
		let controller = DescriptionViewController(with: Description.init(name: monster.name, description: monster.desc))
		appNavigator?.go(controller: controller, mode: .push)
	}
}
