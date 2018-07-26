import UIKit

class MenuTableViewController: UITableViewController {
  weak var delegate: MenuViewController?
 
  @IBAction func mainButtonTap(_ sender: Any) {
    self.view.window?.set(mainStoryboard: Storyboards.main.rawValue,
                          animated: false,
                          condition: { (window) -> Bool in
                            if let root = window.rootViewController as? UINavigationController,
                              let _ = root.viewControllers.first as? MenuViewController {
                              return false
                            }
                            return true
    }, completion: nil)
  }
}
