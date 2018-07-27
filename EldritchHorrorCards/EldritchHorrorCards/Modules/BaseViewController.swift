import UIKit

class BaseViewController: UIViewController {
	
	var isHiddenNavigationBar = false
	
	/// navigation won't not open controller twice if controller exclusive and opened
	var isExclusiveController = false
	var isSetAsCurrentController = true
	
	var appNavigator = DI.providers.resolve(NavigatorProtocol.self)
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(isHiddenNavigationBar, animated: true)
		if isSetAsCurrentController {
			appNavigator?.currentController = self
		}
		
		setStatusbar(with: self.statusBarColor())
		UIApplication.shared.statusBarStyle = self.isLightStatusFont ? .lightContent : .default
	}
	
    override var preferredStatusBarStyle : UIStatusBarStyle { return self.isLightStatusFont ? .lightContent : .default }
    
    private func statusBarColor() -> UIColor {
        return .gray
    }
    
    private var isLightStatusFont: Bool {
        guard let identifier = self.restorationIdentifier else { return true }
		return identifier == "AuthViewController"
    }
}
