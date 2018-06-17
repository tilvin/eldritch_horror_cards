class MonsterDetailViewController: UIViewController {
    var monster: Monster!
    
    @IBOutlet private var bgImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _item = monster else { fatalError("No user to display.") }
        bgImageView.loadImageAtURL(monster.imageURLString, withDefaultImage: monster.placeholderImage)
        nameLabel.text = _item.name
        scoreLabel.text = "\(_item.score)"
    }
    
    @IBAction func callMonsterAction(_ sender: AnyObject) {
        print("Call Button Action!")
    }
}
