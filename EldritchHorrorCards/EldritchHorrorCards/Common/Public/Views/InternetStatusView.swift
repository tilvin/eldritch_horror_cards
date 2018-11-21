//
//  InternetStatusView.swift
//  Cubux2
//
//  Created by Andrey Torlopov on 11/22/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

enum InternetStatusType {
	case online, offline
	
	var backGroundColor: UIColor {
		switch self {
		case .online:
			return .darkGreenBlue
		case .offline:
			return .gallery
		}
	}
	
	var textColor: UIColor {
		switch self {
		case .online:
			return .gallery
		case .offline:
			return .darkGreenBlue
		}
	}
	
	var text: String {
		switch self {
		case .online:
			return String(.online)
		case .offline:
			return String(.offline)
		}
	}
}

final class InternetStatusView: UIView {
	
	private lazy var textLabel: UILabel = {
		let view = UILabel(font: UIFont.regular12, textColor: .gallery)
		view.textAlignment = .center
		return view
	}()
	
	//MARK: - Init
	
	init(frame: CGRect, type: InternetStatusType) {
		super.init(frame: frame)
		backgroundColor = type.backGroundColor
		textLabel.textColor = type.textColor
		textLabel.text = type.text
		addSubviews()
		makeConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - Private
	
	private func addSubviews() {
		addSubview(textLabel)
	}
	
	private func makeConstraints() {
		textLabel.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
	}
}
