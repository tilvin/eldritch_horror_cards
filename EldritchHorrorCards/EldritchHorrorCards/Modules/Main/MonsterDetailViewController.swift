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
        print("Call Button Action!")
    }
    @IBAction private func infoAboutMonster(_ sender: Any) {
    }
}
