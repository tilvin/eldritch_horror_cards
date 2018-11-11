//
//  CustomButton.swift
//  Ebs
//
//  Created by Vitalii Poponov on 13.04.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

enum CustomButtonType {
	case darkGreenBlue
	case light
	case close
}

extension CustomButton {
	
	struct Appearance {
		let cornerRadius: CGFloat = 3
		let borderWidth: CGFloat = 0
		let highlightedAlpha: CGFloat = 0.7
		let shadowRadius: CGFloat = 0
		let shadowOffset = CGSize(width: 0, height: 0)
		let closeButtonAlpha: CGFloat = 0.2
	}
}

final class CustomButton: UIButton {
	
	private let appearance = Appearance()

	public var isFrozen: Bool = false {
		didSet {
			self.updateAppearance()
		}
	}

	//MARK: - Private variables
	
	private let type: CustomButtonType
	
	private var buttonBackgroundColor: UIColor {
		switch self.type {
		case .darkGreenBlue:
			return self.isHighlighted ? UIColor.darkGreenBlue.withAlphaComponent(appearance.highlightedAlpha) : UIColor.darkGreenBlue
		case .light:
			return self.isHighlighted ? UIColor.gallery : UIColor.white
		case .close:
			return self.isHighlighted ? UIColor.black.withAlphaComponent(appearance.closeButtonAlpha * 2) : UIColor.black.withAlphaComponent(appearance.closeButtonAlpha)
		}
	}

	private var buttonBackgroundFrozenColor: UIColor {
		switch self.type {
		case .darkGreenBlue:
			return self.isHighlighted ? UIColor.mako.withAlphaComponent(appearance.highlightedAlpha) : UIColor.mako
		case .light:
			return self.isHighlighted ? UIColor.gallery : UIColor.white
		case .close:
			return self.isHighlighted ? UIColor.black.withAlphaComponent(appearance.closeButtonAlpha * 2) : UIColor.black.withAlphaComponent(appearance.closeButtonAlpha)
		}
	}
	
	private var titleBackgroundColor: UIColor {
		switch self.type {
		case .darkGreenBlue:
			return .white
		case .light:
			return .black
		case .close:
			return .black
		}
	}
	
	//MARK: - Inits
	
	init(type: CustomButtonType) {
		self.type = type
		
		super.init(frame: .zero)
		self.titleLabel?.font = UIFont.bold16
		self.titleLabel?.lineBreakMode = .byWordWrapping
		self.titleLabel?.textAlignment = .center
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Lifecycle
	
	override var isHighlighted: Bool {
		didSet {
			updateAppearance()
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		updateAppearance()
		updateStyles()
	}

	//MARK: - Private
	
	private func updateAppearance() {
		titleLabel?.textColor = titleBackgroundColor
		backgroundColor = isFrozen ? buttonBackgroundFrozenColor : buttonBackgroundColor
	}
	
	private func updateStyles() {
		switch type {
		case .close:
			layer.cornerRadius = min(frame.width, frame.height) / 2
			layer.shadowOpacity = 1
			layer.shadowColor = UIColor.black.withAlphaComponent(appearance.closeButtonAlpha).cgColor
			layer.masksToBounds = false
		default:
			layer.cornerRadius = appearance.cornerRadius
			layer.shadowOpacity = 0
			layer.masksToBounds = false
		}
	}
}
