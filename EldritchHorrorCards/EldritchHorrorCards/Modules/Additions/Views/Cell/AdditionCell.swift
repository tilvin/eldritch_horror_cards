//
//  PartnerCell.swift
//  Ebs
//
//  Created by Ильнур Ягудин on 20.07.2018.
//  Copyright © 2018 Vitalii Poponov. All rights reserved.
//

import UIKit

extension AdditionCell {

	struct Appearance {
//		let backgroundColor = UIColor.clear
//		let cornerRadius: CGFloat = 8
//		let shadowColor = UIColor.black
	}
}

protocol AdditionCellDelegate: class {
	func update(with model: Addition)
	func infoPressed(with model: Addition)
}

class AdditionCell: BaseTableViewCell {

	let appearance = Appearance()
	var model: Addition!
	var delegate: AdditionCellDelegate?

	lazy var titleLabel: UILabel = {
		let view = UILabel()
		view.font = UIFont.bold16
		view.textColor = UIColor.mako
		return view
	}()

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
		view.setImage(UIImage.mapOn, for: .normal)
		return view
	}()

	lazy var separateLine: UIView = {
		let view = UIView()
		view.backgroundColor = .alto
		return view
	}()

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

	public func update(with viewModel: Addition) {
		model = viewModel
		titleLabel.text = model.name
		mapButton.setImage(model.isSelectedMap ? .mapOn : .mapOff, for: .normal)
		mapButton.isHidden = !model.isMap
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

	@objc private func switchPressed() {
		print("switch! \(selectSwitch.isOn)")
		model.isSelected = selectSwitch.isOn
		delegate?.update(with: model)
	}

	@objc private func mapPressed() {
		print("map pressed")
		model.isSelectedMap = mapButton.alpha == 1
		delegate?.update(with: model)
	}

	@objc private func infoPressed() {
		print("indo pressed")
		delegate?.infoPressed(with: model)
	}
}


//class AdditionCell: UITableViewCell, ConfigurableCell {
//	@IBOutlet private(set) var titleLabel: UILabel!
//	@IBOutlet private(set) var borderView: UIView!
//	@IBOutlet private(set) var mapButton: UIButton!
//
//	override func awakeFromNib() {
//		super.awakeFromNib()
//		borderView.shadowOpacity = 1
//		borderView.borderColor = .alto
//		mapButton.alpha = 0.5
//	}
//
//	override func setSelected(_ selected: Bool, animated: Bool) {
//		super.setSelected(selected, animated: animated)
//		borderView.shadowOpacity = selected ? 0 : 1
//		borderView.borderColor = selected ?  .elm : .alto
//	}
//
//	override func layoutSubviews() {
//		super.layoutSubviews()
//		contentView.layoutIfNeeded()
//	}
//
//	func configure(with item: Addition) {
//		titleLabel.text = item.name
//		mapButton.isHidden = !item.isMap
//		mapButton.alpha = item.isSelectedMap ? 1 : 0.5
//	}
//}
