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
		if isSetAsCurrentController { appNavigator?.currentController = self }
	}
	
	override var preferredStatusBarStyle: UIStatusBarStyle { return .default }
    
    public func processing(_ isEnabled: Bool) {
        if isEnabled {
            view.showProccessing()
        }
        else {
            view.hideProccessing()
        }
    }
    
    public func showErrorAlert(type: AlertType = .warning, message: String?, completion: (() -> Void)? = nil) {
        let alert = AlertHelper.alertWith(
            title: type.title,
            message: message ?? String(.unknownError),
            controller: self,
            buttons: nil) { (_, _, _) in
                completion?()
        }
        present(alert, animated: true, completion: nil)
    }
}

class TabBarAddableController: BaseViewController {
	
	required init(tabBarItem: UITabBarItem) {
		super.init(nibName: nil, bundle: nil)
		self.tabBarItem = tabBarItem
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}
