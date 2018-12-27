//
//  BaseNavigationController.swift
//  Ebs
//
//  Created by Ильнур Ягудин on 18.07.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

extension BaseNavigationController {
	
	struct Appearance {
		let isTranslucent = false
	}
}

final class BaseNavigationController: UINavigationController {
	
	//MARK: - Public variables
	
	private let appearance = Appearance()
	
	//MARK: - Lifecycle
	
	deinit {
		delegate = nil
		interactivePopGestureRecognizer?.delegate = nil
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
		interactivePopGestureRecognizer?.delegate = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationBar.isTranslucent = appearance.isTranslucent
	}
	
	override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
		super.pushViewController(viewController, animated: animated)
		
		if let baseViewController = viewController as? BaseViewController {
			if !baseViewController.isHiddenBackButton {
				appendBackButton()
			}
			else {
				viewController.navigationItem.setHidesBackButton(true, animated: false)
				visibleViewController?.navigationItem.setHidesBackButton(true, animated: false)
			}
		}
		else {
			appendBackButton()
		}
	}
	
	override public func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
		super.setViewControllers(viewControllers, animated: animated)
		if viewControllers.count > 1 {
			appendBackButton()
		}
	}
	
	//MARK: - Public
	
	public func enableBackButton() {
		let backButton = UIBarButtonItem.backButton (target: self, action: #selector(backAction))
		visibleViewController?.navigationItem.leftBarButtonItem = backButton
	}
	
	//MARK: - Private
	
	private func appendBackButton() {
		if viewControllers.count > 1 {
			enableBackButton()
		}
	}
	
	@objc private func backAction() {
		if viewControllers.count > 1 {
			_ = popViewController(animated: true)
		}
		else {
			dismiss(animated: true, completion: nil)
		}
	}
}
// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
	
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		guard let navigationController = navigationController as? BaseNavigationController else { return }
		navigationController.interactivePopGestureRecognizer?.isEnabled = viewController != navigationController.viewControllers.first
	}
}

// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationController: UIGestureRecognizerDelegate { }
