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
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		borderView.shadowOpacity = selected ? 0 : 1
		borderView.borderColor = selected ?  .elm : .alto
		mapButton.isEnabled = selected
		if !selected { mapButton.alpha = 1}
		if selected { mapButton.alpha = 1 }
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()	
		contentView.layoutIfNeeded()
	}
	
	func configure(with item: Addition) {
		titleLabel.text = item.name
		mapButton.alpha = item.isMap ? 1 : 0.5
	}	
}
