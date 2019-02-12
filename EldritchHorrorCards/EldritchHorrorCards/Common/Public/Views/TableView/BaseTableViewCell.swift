//
//  BaseTableViewCell.swift
//
// Created by Andrey Torlopov on 9/4/18.
// Copyright (c) 2018 Andrey Torlopov. All rights reserved.
//


import UIKit

class BaseTableViewCell: UITableViewCell {

	var object: Any? {
		didSet {
			didSetObject(object: object)
		}
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

	internal func didSetObject(object: Any?) {
	}
}
