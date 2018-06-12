import RealmSwift

protocol MenuEmbedProtocol: class {
  var menuContainerView: UIView { get}
  var menuAction: CommandWith<Command>! { get set }
  func setupMenu()
}

extension MenuEmbedProtocol where Self: UIViewController {
  
  func setupMenu() {
    let controller = MenuViewController.controllerFromStoryboard(.menu)
    controller.setup(completion: { [weak self] (command) in
      self?.menuAction = command
    })
    menuContainerView.isHidden = true
    menuContainerView.embed(subview: controller.view)
    addChildViewController(controller)
    controller.didMove(toParentViewController: self)
  }
}

final class MenuViewController: UIViewController {
  @IBOutlet private var backgroundView: UIView!
  @IBOutlet private var contentView: UIView!
  @IBOutlet private(set) var avatarImageView: UIImageView!
  @IBOutlet private(set) var firstNameLabel: UILabel!
  @IBOutlet private(set) var lastNameLabel: UILabel!
  @IBOutlet private var synchronLabel: UILabel!
  @IBOutlet private var syncButton: UIButton!
  
  private var isSlided: Bool = false
  private var menuAction: CommandWith<Command>!
  private var setupAction: (() -> Void)?
  private var backgroundTapCmd: Command?
//  private var realm: Realm!
  
  // MARK: - Lifecycle
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    realm = getRealm()
//    users = realm.objects(User.self)
    reloadMenu()
    
    menuAction = CommandWith<Command>(action: { [weak self] (cmd) in
      guard let s = self else { return }
      if let vc = s.parent as? MenuEmbedProtocol {
        vc.menuContainerView.isHidden = !vc.menuContainerView.isHidden
      }
      s.backgroundTapCmd = cmd
      s.set(slided: !s.isSlided, animated: true)
    })
    setupAction?()
    set(slided: isSlided)
  }
  
  func setup(completion: @escaping (CommandWith<Command>) -> Void) {
    setupAction = { [weak self] in
      completion((self?.menuAction)!)
    }
  }
  
  // MARK: - Handlers
  
  @IBAction private func backgroundTap(_ sender: Any) {
    backgroundTapCmd?.perform()
    set(slided: !isSlided, animated: true)
  }  
}

// MARK: - Sliding
extension MenuViewController {
  
  fileprivate func set(slided: Bool, animated: Bool = false, prepareToStart: Bool = true) {
    isSlided = slided
    contentView.superview?.isHidden = false
    if prepareToStart {
      self.contentView.frame.origin.x = slided ? -self.contentView.frame.width : -40
      self.backgroundView.alpha = !slided ? 0 : 1
    }
    
    let animations = {
      self.contentView.frame.origin.x = !slided ? -self.contentView.frame.width : -40
      self.backgroundView.alpha = slided ? 1 : 0
    }
    
    let completion: (Bool) -> Void = { [weak self] _ in
      guard let s = self else { return }
      s.contentView.superview?.isHidden = !slided
      if let vc = s.parent as? MenuEmbedProtocol {
        vc.menuContainerView.isHidden = !slided
      }
      if slided {
        s.reloadMenu()
      }
    }
    
    if animated {
      UIView.animate(withDuration: 0.7,
                     delay: 0.0,
                     usingSpringWithDamping: 0.5,
                     initialSpringVelocity: 0.0,
                     options: .curveEaseInOut, animations: animations, completion: completion)
      
      if slided {
        UIView.animate(withDuration: 0.25,
                       delay: 0.3,
                       options: .curveLinear,
                       animations: {
                        self.contentView.frame.origin.x = 0
        }, completion: nil)
      }
    } else {
      animations()
      if slided { contentView.frame.origin.x = 0 }
      completion(false)
    }
  }
}

// MARK: -

extension MenuViewController {
  
  private func reloadMenu() {
    Log.writeLog(logLevel: .debug, message: "Reload menu method!")
  }
}

// MARK: - Segue

extension MenuViewController {

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? MenuTableViewController {
      vc.delegate = self
    }
  }
}
