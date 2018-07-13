//
//  Navigator.swift
//  App-demo
//
//  Created by Ильнур Ягудин 16.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

class AppNavigator: NavigatorProtocol {
	
	var currentController: BaseViewController?
	
	func go(controller: BaseViewController, mode: NavigatorPresentationMode) {
		display(controller: controller, mode: mode)
	}
	
	func create(_ app: AppDelegate, rootController: BaseViewController) {
		app.window = UIWindow(frame: UIScreen.main.bounds)
		app.window?.backgroundColor = UIColor.white
		app.window?.makeKeyAndVisible()
		
		let navController = UINavigationController(rootViewController: rootController)
		app.window?.rootViewController = navController
		currentController = rootController
	}
	
	private var safetyCurrentController: BaseViewController {
		guard let current = self.currentController else {
			fatalError("Call create method before use navigation.")
		}
		return current
	}
	
	private func display(controller: UIViewController, mode: NavigatorPresentationMode) {
		if let current = currentController, current.isExclusiveController, current.isKind(of: type(of: controller)) {
			return
		}
	
		switch mode {
		case .push:
			
			guard let navController = safetyCurrentController.navigationController else {
				present(controller: controller)
				return
			}
			navController.pushViewController(controller, animated: true)
			
		case .modalWithNavigation:
			
			let navController = UINavigationController(rootViewController: controller)
			present(controller: navController)
			
		case .replace:
			
			guard let navController = safetyCurrentController.navigationController else {
				present(controller: controller)
				return
			}
			navController.setViewControllers([controller], animated: false)
			
		case .replaceWithPush:
			
			guard let navController = safetyCurrentController.navigationController else {
				present(controller: controller)
				return
			}
			navController.pushViewController(controller, animated: true)
			let controllers = navController.viewControllers.filter { $0 != currentController }
			navController.setViewControllers(controllers, animated: false)
		case .modal:
			present(controller: controller)
		}
	}
	
	private func present(controller: UIViewController) {
		safetyCurrentController.present(controller, animated: true, completion: nil)
	}
}
