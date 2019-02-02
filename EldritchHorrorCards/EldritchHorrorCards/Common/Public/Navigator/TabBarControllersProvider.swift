//
//  TabBarControllersProvider.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import UIKit

class TabBarControllersProvider: TabBarControllersProviderProtocol {
	func registeredControllers() -> [TabBarAddableController] {
		return [] // [AuthViewController.controllerFromStoryboard(.main)]
		//[AuthViewController(tabBarItem: UITabBarItem(title: "Auth", image: UIImage(named: "close_button"), tag: 0))]
	}
}
