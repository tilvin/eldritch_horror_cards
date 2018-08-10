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
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()	
		contentView.layoutIfNeeded()
	}
	
	func configure(with item: Addition) {
		titleLabel.text = item.name
	}
}
