class AuthViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction private func authTap(_ sender: Any) {
    Router.presentMonsters(parent: self, inputParams: [:])
  }
}
