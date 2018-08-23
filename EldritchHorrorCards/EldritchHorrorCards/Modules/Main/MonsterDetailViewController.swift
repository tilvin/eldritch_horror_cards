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
		let vc = CardViewController.controllerFromStoryboard(.main)
		vc.modalTransitionStyle = .crossDissolve
		appNavigator?.go(controller: vc, mode: .modal)
	}
	
	@IBAction private func infoAboutMonster(_ sender: Any) {
		let controller = MonsterDescriptionViewController(with: monster)
		controller.modalTransitionStyle = .flipHorizontal
		appNavigator?.go(controller: controller, mode: .modal)
	}
}
