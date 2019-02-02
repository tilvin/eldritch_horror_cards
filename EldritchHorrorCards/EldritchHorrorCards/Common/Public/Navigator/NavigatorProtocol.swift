//
//  NavigatorProtocol.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import Foundation

enum NavigatorPresentationMode {
	
	///Standard pushViewController presentation with default iOS animation.
	case push
	
	///Modal presentation with custom transition.
	case modal
	
	///Modal presentation with navigation controller.
	case modalWithNavigation
	
	///Replaces the view controllers currently managed by the navigation controller with your view controller.
	case replace
	
	///Replaces only current view controller currently managed by the navigation controller with your view controller.
	case replaceWithPush
}

protocol NavigatorProtocol {
	var currentController: BaseViewController? { get set }
	func go(controller: BaseViewController, mode: NavigatorPresentationMode, animated: Bool)
	func create(_ app: AppDelegate)
	func goMain()
}

extension NavigatorProtocol {
	func go(controller: BaseViewController, mode: NavigatorPresentationMode, animated: Bool = true) {
		go(controller: controller, mode: mode, animated: animated)
	}
}
