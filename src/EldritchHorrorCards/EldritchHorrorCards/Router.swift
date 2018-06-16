
class Router {
    static var completionKey: String { return "completion" }
    
    static func presentMonsters(parent: UIViewController, inputParams: [String: Any] = [:]) {
        let controller = MonstersViewController.controllerFromStoryboard(.main)
        let nc = UINavigationController(rootViewController: controller)
        controller.modalTransitionStyle = .crossDissolve
        parent.present(nc, animated: true, completion: nil)
    }
    
    static func presentAuth(parent: UIViewController? = nil, inputParams: [String: Any] = [:]) {
        var parentController: UIViewController!
        if parent != nil {
            parentController = parent
        } else if let appDelegate  = UIApplication.shared.delegate as? AppDelegate,
            let vc = appDelegate.window!.rootViewController {
            parentController = vc
        } else {
            fatalError()
        }
        
        let controller = AuthViewController.controllerFromStoryboard(.main)
        controller.modalTransitionStyle = .crossDissolve
        parentController.present(controller, animated: true, completion: nil)
    }
    
}
