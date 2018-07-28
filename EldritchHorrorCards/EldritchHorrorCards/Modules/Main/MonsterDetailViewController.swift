import UIKit

class MonsterDetailViewController: BaseViewController {
    var monster: Monster!
    
    @IBOutlet private var bgImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		isHiddenNavigationBar = true
        guard let _item = monster else { fatalError("No user to display.") }
        bgImageView.loadImageAtURL(monster.imageURLString, withDefaultImage: monster.placeholderImage)
        nameLabel.text = "\(_item.name) (\(_item.score))"
    }
    
    @IBAction func callMonsterAction(_ sender: AnyObject) {
        let vc = CardViewController.controllerFromStoryboard(.main)
        vc.modalTransitionStyle = .crossDissolve
        appNavigator?.go(controller: vc, mode: .modal)
    }
	
    @IBAction private func infoAboutMonster(_ sender: Any) {
		print("detail info about monster!")
	}
}
