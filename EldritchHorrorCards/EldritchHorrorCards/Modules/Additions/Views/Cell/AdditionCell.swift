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
		let titleLabelColor = UIColor.black
		let descriptionColor = UIColor.white
		let descriptionFont = UIFont.bold28
		let titleFont = UIFont.bold28
		let spacingBetweenIconAndText: CGFloat = 8
		let spacingBetweenTitleAndDescription: CGFloat = 4
		let leftOrTopOffset = 16
		var rightOrBottomOffset: Int { return -leftOrTopOffset }
		
		let roundedViewTopOffset = 8
		var roundedViewBottomOffset: Int { return -roundedViewTopOffset }
		
		let roundedViewColor = UIColor.white
		let backgroundColor = UIColor.clear
		
		let shadowOffset = CGSize(width: 0, height: 0)
		let shadowOpacity: Float = 0.15
		let shadowRadius: CGFloat = 12
		let cornerRadius: CGFloat = 8
		let shadowColor = UIColor.black
	}
}

class AdditionCell: BaseTableViewCell {
	
	let appearance = Appearance()
	var model: Addition!
	
	lazy var titleLabel: UILabel = {
		let view = UILabel()
		view.font = UIFont.bold16
		view.textColor = UIColor.mako
		view.text = "model.name"
		view.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
		return view
	}()
	
	lazy var selectSwitch: UISwitch = {
		let view = UISwitch()
		view.onTintColor = UIColor.darkGreenBlue
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
		verticalStack.distribution = .fill
		verticalStack.spacing = 10
		
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
		
		let view = UIView()
		view.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
		buttonStack.addArrangedSubview(view)
		
		verticalStack.addArrangedSubview(titleStack)
		verticalStack.addArrangedSubview(buttonStack)
		
		return verticalStack
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviews()
		makeConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		addSubviews()
		makeConstraints()
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
