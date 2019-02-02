//
//  Navigator.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import UIKit

final class AppNavigator: NSObject, NavigatorProtocol {
	
	var currentController: BaseViewController?
	var tabBarControllersProvider: TabBarControllersProviderProtocol
	let tabBarController: BaseTabBarController
	var app: AppDelegate?
	
	init(tabBarControllersProvider: TabBarControllersProviderProtocol = DI.providers.resolve(TabBarControllersProviderProtocol.self)!) {
		self.tabBarControllersProvider = tabBarControllersProvider
		tabBarController = BaseTabBarController()
	}
	
	func go(controller: BaseViewController, mode: NavigatorPresentationMode, animated: Bool) {
		display(controller: controller, mode: mode, animated: animated)
	}
	
	func create(_ app: AppDelegate) {
		self.app = app
		makeWindowVisible(app)
		goMain()
	}
	
	func goMain() {
		let controller = AdditionsViewController()
		self.app?.window?.rootViewController = controller
		currentController = controller
	}
	
	private var safetyCurrentController: BaseViewController {
		guard let current = self.currentController else {
			fatalError("Call create method before use navigation.")
		}
		return current
	}
	
	private func display(controller: UIViewController, mode: NavigatorPresentationMode, animated: Bool) {
		if let current = currentController, current.isExclusiveController, current.isKind(of: type(of: controller)) { return }
		
		switch mode {
		case .push:
			guard let navController = safetyCurrentController.navigationController else {
				present(controller: controller, animated: animated)
				return
			}
			navController.pushViewController(controller, animated: animated)
		case .modalWithNavigation:
			let navController = BaseNavigationController(rootViewController: controller)
			present(controller: navController, animated: animated)
		case .replace:
			guard let navController = safetyCurrentController.navigationController else {
				present(controller: controller, animated: animated)
				return
			}
			navController.setViewControllers([controller], animated: animated)
		case .replaceWithPush:
			guard let navController = safetyCurrentController.navigationController else {
				present(controller: controller, animated: animated)
				return
			}
			navController.pushViewController(controller, animated: animated)
			let controllers = navController.viewControllers.filter { $0 != currentController }
			navController.setViewControllers(controllers, animated: false)
		case .modal:
			present(controller: controller, animated: animated)
		}
	}
	
	private func present(controller: UIViewController, animated: Bool) {
		safetyCurrentController.present(controller, animated: animated, completion: nil)
	}
	
	private func makeWindowVisible(_ app: AppDelegate) {
		app.window = UIWindow(frame: UIScreen.main.bounds)
		app.window?.backgroundColor = UIColor.white
		app.window?.makeKeyAndVisible()
	}
}

extension AppNavigator: UITabBarControllerDelegate {
	
	func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
		currentController = (viewController as? UINavigationController)?.topViewController as? BaseViewController
	}
}
