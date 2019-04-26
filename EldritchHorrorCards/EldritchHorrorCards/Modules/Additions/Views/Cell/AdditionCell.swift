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

final class AdditionCell: BaseTableViewCell {
	
	var model: AdditionModel!
	
	var delegate: AdditionCellDelegate?
	
	var titleLabel = UILabel(font: .bold16, textColor: .mako)
	
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
		titleStack.spacing = 5
		
		titleStack.addArrangedSubview(titleLabel)
		titleStack.addArrangedSubview(selectSwitch)
		
		var buttonStack = UIStackView()
		buttonStack.axis = .horizontal
		buttonStack.distribution = .fill
		buttonStack.spacing = 20
		
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
		mapButton.alpha = model.isSelectedMap ? 1 : 0.5
		mapButton.isHidden = !model.hasMap
		selectSwitch.isOn = model.isSelected
	}
	
	private func addSubviews() {
		addSubview(stackView)
		addSubview(separateLine)
	}
	
	private func makeConstraints() {
		stackView.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview().inset(20)
			make.top.equalToSuperview().inset(20)
			make.bottom.equalToSuperview().inset(20)
		}
		
		separateLine.snp.makeConstraints { (make) in
			make.height.equalTo(1)
			make.bottom.equalToSuperview()
			make.left.equalToSuperview().inset(20)
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
		mapButton.alpha = mapButton.alpha == 1 ? 0.5 : 1
		model.isSelectedMap = mapButton.alpha == 1
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
