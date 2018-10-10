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
		let cardProvider = DI.providers.resolve(CardDataProviderProtocol.self)!
		let ancient = monster.id
		
		provider.selectAncient(gameId: gameProvider.game.id, ancient: ancient) { [weak self] (success) in
			if success {
				
				print("Monster is unload!")
				cardProvider .load(gameId: gameProvider.game.id) { [weak self] (success) in
					guard let sSelf = self else { return }
					if success {
						
						print("Card is load!")
						let controller = CardViewController.controllerFromStoryboard(.main)
						controller.modalTransitionStyle = .crossDissolve
						sSelf.appNavigator?.go(controller: controller, mode: .modal)
					}
					else {
						print("error!")
					}
				}
			}
			else {
				print("error!")
			}
		}
	}
	
	@IBAction private func infoAboutMonster(_ sender: Any) {
		let controller = DescriptionViewController(with: Description.init(name: monster.name, description: monster.description))
		appNavigator?.go(controller: controller, mode: .push)
	}
}
