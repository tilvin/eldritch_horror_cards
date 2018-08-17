//
//  AdditionTableViewCell.swift
//  EldritchHorrorCards
//
//  Created by Andrey Torlopov on 8/10/18.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class AdditionTableViewCell: UITableViewCell, ConfigurableCell {
	@IBOutlet private(set) var titleLabel: UILabel!
	@IBOutlet private(set) var borderView: UIView!
	@IBOutlet private(set) var mapButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		borderView.shadowOpacity = selected ? 0 : 1
		mapButton.isEnabled = selected ?  true : false
		selectionStyle = .none
		borderView.borderColor = selected ?  .elm : .alto
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()	
		contentView.layoutIfNeeded()
	}
	
	func configure(with item: Addition) {
		titleLabel.text = item.name
		mapButton.alpha = item.map ?  1 : 0
	}	
}
