//import RealmSwift
//import Crashlytics

class MainViewController: BaseViewController {
  @IBOutlet private var menuContainer: UIView!
  
  var menuContainerView: UIView { return self.menuContainer }
  var menuAction: CommandWith<Command>!
  
  // MARK: - Lifecycle
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMenu()
  }
  
  @IBAction private func menuTap(_ sender: Any) {
    let reloadCmd = Command {  (_) in
      Log.writeLog(logLevel: .info, message: "reload view!")
    }
    menuAction?.perform(with: reloadCmd)
  }
}

extension MainViewController: MenuEmbedProtocol {}
