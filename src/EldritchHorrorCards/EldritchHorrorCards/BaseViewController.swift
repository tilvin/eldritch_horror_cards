class BaseViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIViewController.setStatusbar(with: self.statusBarColor())
        UIApplication.shared.statusBarStyle = self.isLightStatusFont ? .lightContent : .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle { return self.isLightStatusFont ? .lightContent : .default }
    
    private func statusBarColor() -> UIColor {
        return .gray
    }
    
    private var isLightStatusFont: Bool {
        guard let identifier = self.restorationIdentifier else { return true }
        switch identifier {
        case "AuthViewController", "TutorialLoaderViewController", "TutorialPageController", "TutorialViewController":
            return false
        default:
            return true
        }
    }
}
