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
		var rightOrBottomOffset: Int {
			return -leftOrTopOffset
		}
		
		let roundedViewTopOffset = 8
		var roundedViewBottomOffset: Int {
			return -roundedViewTopOffset
		}
		
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
		view.numberOfLines = 0
		view.textColor = appearance.titleLabelColor
		view.font = appearance.titleFont
		return view
	}()
	
	lazy var descriptionLabel: UILabel = {
		let view = UILabel()
		view.numberOfLines = 0
		view.textColor = appearance.descriptionColor
		view.font = appearance.descriptionFont
		
		return view
	}()
	
	lazy var partnerIcon: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
		return view
	}()
	
	lazy var contentStackView: UIStackView = {
		var stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.distribution = .fill
		stackView.spacing = appearance.spacingBetweenIconAndText
		return stackView
	}()
	
	lazy var labelsStackView: UIStackView = {
		var stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.spacing = appearance.spacingBetweenTitleAndDescription
		return stackView
	}()
	
	lazy var roundedView: UIView = {
		let view = UIView()
		view.backgroundColor = appearance.roundedViewColor
		return view
	}()
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubviews()
		makeConstraints()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		roundedView.layer.addShadow(with: appearance.shadowOffset,
							 opacity: appearance.shadowOpacity,
							 shadowRadius: appearance.shadowRadius,
							 cornerRadius: appearance.cornerRadius,
							 color: appearance.shadowColor)
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		let whiteBackgroundView = UIView(frame: self.frame)
		whiteBackgroundView.backgroundColor = .clear
		self.selectedBackgroundView = whiteBackgroundView
		super.setSelected(selected, animated: animated)
		roundedView.backgroundColor = selected ? .gray : .white
	}
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		
		roundedView.backgroundColor = highlighted ? .gray : .white
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		addSubviews()
		makeConstraints()
	}
	
	public func update(with viewModel: Addition) {
		model = viewModel
		print("configure cell with model: \(viewModel)")
//		partnerIcon.image = viewModel.image
//		titleLabel.text = viewModel.title.uppercased()
//		descriptionLabel.text = viewModel.description
//		descriptionLabel.isHidden = viewModel.description == nil
	}
	
	private func addSubviews() {
		contentView.backgroundColor = appearance.backgroundColor
		backgroundColor = appearance.backgroundColor
		contentView.addSubview(roundedView)
		roundedView.addSubview(contentStackView)
		
		contentStackView.addArrangedSubview(partnerIcon)
		contentStackView.addArrangedSubview(labelsStackView)
		
		labelsStackView.addArrangedSubview(titleLabel)
		labelsStackView.addArrangedSubview(descriptionLabel)
	}
	
	private func makeConstraints() {
		roundedView.snp.remakeConstraints { (maker) in
			maker.bottom.equalToSuperview().offset(appearance.roundedViewBottomOffset)
			maker.top.equalToSuperview().offset(appearance.roundedViewTopOffset)
			maker.left.equalToSuperview().offset(appearance.leftOrTopOffset).priority(999)
			maker.right.equalToSuperview().offset(appearance.rightOrBottomOffset).priority(999)
		}
		
		contentStackView.snp.remakeConstraints { (maker) in
			maker.bottom.equalToSuperview().offset(appearance.rightOrBottomOffset)
			maker.top.equalToSuperview().offset(appearance.leftOrTopOffset)
			maker.left.equalToSuperview().offset(appearance.leftOrTopOffset).priority(999)
			maker.right.equalToSuperview().offset(appearance.rightOrBottomOffset).priority(999)
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
