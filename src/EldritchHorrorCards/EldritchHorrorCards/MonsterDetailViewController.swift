class MonsterDetailViewController: UIViewController {
    var monster: Monster?
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityStZipLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      guard let _item = monster else { fatalError("No user to display.") }
      bgImageView.image = _item.image
      titleLabel.text = _item.name
      addressLabel.text = _item.detailTextLineOne
      cityStZipLabel.text = _item.detailTextLineTwo
    }
    
    @IBAction func callButtonAction(_ sender: AnyObject) {
      print("Call Button Action!")
    }
    
    @IBAction func emailButtonAction(_ sender: AnyObject) {
      print("Email Button Action!")
    }
}
