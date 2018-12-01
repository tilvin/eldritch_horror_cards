import UIKit

enum TabbarItemType: Int {
	case first = 0
	case second = 1
}

class BaseViewController: UIViewController {
	
	var isHiddenNavigationBar = false
	/// navigation won't not open controller twice if controller exclusive and opened
	var isExclusiveController = false
	var isSetAsCurrentController = true
	var appNavigator = DI.providers.resolve(NavigatorProtocol.self)
	var isSelectable: Bool = true
	var isHiddenBackButton: Bool = false
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.setNavigationBarHidden(isHiddenNavigationBar, animated: true)
		navigationController?.navigationItem.setHidesBackButton(isHiddenBackButton, animated: true)
		
		if isSetAsCurrentController {
			appNavigator?.currentController = self
		}
	}
	
	public func setTabbarItem(with type: TabbarItemType) {
		guard let tabBarController = tabBarController else { return }
		if type.rawValue == tabBarController.selectedIndex {
			navigationController?.popToRootViewController(animated: true)
		}
		else {
			tabBarController.selectedIndex = type.rawValue
		}
		appNavigator?.currentController = (tabBarController.selectedViewController as? UINavigationController)?.topViewController as? BaseViewController
	}
	
	public func processing(_ isEnabled: Bool) {
		if isEnabled {
			view.showProccessing()
		}
		else {
			view.hideProccessing()
		}
	}
	
	public func showErrorAlert(message: String?, completion: (() -> Void)? = nil) {
		let alert = AlertHelper.alertWith(
			title: String(.error),
			message: message ?? String(.unknownError),
			controller: self,
			buttons: nil) { (_, _, _) in
				completion?()
		}
		present(alert, animated: true, completion: nil)
	}
	
	public func internetState(isConnected: Bool) {
		view.showInternetStatus(isConnected: isConnected)
		
		if isConnected {
			DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
				self.view.hideInternetStatus()
			}
		}
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
