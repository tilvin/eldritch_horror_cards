//
//  AdditionTableViewCell.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 8/10/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class AdditionCell: UITableViewCell, ConfigurableCell {
	@IBOutlet private(set) var titleLabel: UILabel!
	@IBOutlet private(set) var borderView: UIView!
	@IBOutlet private(set) var mapButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		borderView.shadowOpacity = 1
		borderView.borderColor = .alto
		mapButton.alpha = 0.5
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		borderView.shadowOpacity = selected ? 0 : 1
		borderView.borderColor = selected ?  .elm : .alto
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()	
		contentView.layoutIfNeeded()
	}
	
	func configure(with item: Addition) {
		titleLabel.text = item.name
		mapButton.isHidden = !item.isMap
		mapButton.alpha = item.isSelectedMap ? 1 : 0.5
	}	
}
