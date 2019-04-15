//
//  PartnerCell.swift
//  EldritchHorrorCards
//
//  Created by Torlopov Andrey on 01.02.2019.
//  Copyright © 2019 Torlopov Andrey. All rights reserved.
//

import UIKit

//TODO: need refactoring

protocol AdditionCellDelegate: class {
	func update(with model: AdditionModel)
	func infoPressed(with model: AdditionModel)
}

extension AdditionCell {
	
	struct Appearance {
		let titleStackSpacing: CGFloat = 5
		let buttonStackSpacing: CGFloat = 20
		let buttonAlphaEnebled: CGFloat = 1
		let buttonAlphaDisabled: CGFloat = 0.5
		let stackViewLeftRightTopBottomOffset: CGFloat = 20
		let separateLineHeight: CGFloat = 1
		let separateLineLeftOffset: CGFloat = 20
	}
}

final class AdditionCell: BaseTableViewCell {
	
	var model: AdditionModel!
	
	var delegate: AdditionCellDelegate?
	
	var titleLabel = UILabel(font: .bold16, textColor: .mako)
	
	private let appearance = Appearance()
	
	lazy var selectSwitch: UISwitch = {
		let view = UISwitch()
		view.onTintColor = .darkGreenBlue
		view.isOn = false
		return view
	}()
	
	lazy var infoButton: UIButton = {
		let view = UIButton()
		view.contentMode = .scaleAspectFit
		view.setImage(UIImage.info, for: .normal)
		return view
	}()
	
	lazy var mapButton: UIButton = {
		let view = UIButton()
		view.contentMode = .scaleAspectFit
		view.setImage(UIImage.map, for: .normal)
		return view
	}()
	
	var separateLine: UIView = UIView(backgroundColor: .alto)
	
	lazy var stackView: UIStackView = {
		var verticalStack = UIStackView()
		verticalStack.axis = .vertical
		verticalStack.distribution = .fillEqually
		
		var titleStack = UIStackView()
		titleStack.axis = .horizontal
		titleStack.distribution = .fill
		titleStack.alignment = .center
		titleStack.spacing = appearance.titleStackSpacing
		
		titleStack.addArrangedSubview(titleLabel)
		titleStack.addArrangedSubview(selectSwitch)
		
		var buttonStack = UIStackView()
		buttonStack.axis = .horizontal
		buttonStack.distribution = .fill
		buttonStack.spacing = appearance.buttonStackSpacing
		
		buttonStack.addArrangedSubview(infoButton)
		buttonStack.addArrangedSubview(mapButton)
		buttonStack.addArrangedSubview(UIView())
		
		verticalStack.addArrangedSubview(titleStack)
		verticalStack.addArrangedSubview(buttonStack)
		
		return verticalStack
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviews()
		makeConstraints()
		selectSwitch.addTarget(self, action: #selector(switchPressed), for: .touchUpInside)
		mapButton.addTarget(self, action: #selector(mapPressed), for: .touchUpInside)
		infoButton.addTarget(self, action: #selector(infoPressed), for: .touchUpInside)
		layoutIfNeeded()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		addSubviews()
		makeConstraints()
		layoutIfNeeded()
	}
	
	public func update(with viewModel: AdditionModel) {
		model = viewModel
		titleLabel.text = model.name
		mapButton.alpha = model.isSelectedMap ? appearance.buttonAlphaEnebled : appearance.buttonAlphaDisabled
		mapButton.isHidden = !model.hasMap
		selectSwitch.isOn = model.isSelected
	}
	
	private func addSubviews() {
		addSubview(stackView)
		addSubview(separateLine)
	}
	
	private func makeConstraints() {
		stackView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(appearance.stackViewLeftRightTopBottomOffset)
			make.top.equalToSuperview().inset(appearance.stackViewLeftRightTopBottomOffset)
			make.bottom.equalToSuperview().inset(appearance.stackViewLeftRightTopBottomOffset)
		}
		
		separateLine.snp.makeConstraints { (make) in
			make.height.equalTo(appearance.separateLineHeight)
			make.bottom.equalToSuperview()
			make.left.equalToSuperview().inset(appearance.separateLineLeftOffset)
			make.right.equalToSuperview()
		}
	}
	
	//MARK: Handlers
	
	@objc private func switchPressed() {
		model.isSelected = selectSwitch.isOn
		if !model.isSelected {
			model.isSelectedMap = false
		}
		update(with: model)
		delegate?.update(with: model)
	}
	
	@objc private func mapPressed() {
		mapButton.alpha = mapButton.alpha == appearance.buttonAlphaEnebled ? appearance.buttonAlphaDisabled : appearance.buttonAlphaEnebled
		model.isSelectedMap = mapButton.alpha == appearance.buttonAlphaEnebled
		if !selectSwitch.isOn, model.isSelectedMap {
			selectSwitch.isOn = true
			model.isSelected = true
		}
		update(with: model)
		delegate?.update(with: model)
	}
	
	@objc private func infoPressed() {
		delegate?.infoPressed(with: model)
	}
}
