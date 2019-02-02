//
//  BaseTableViewHeaderFooterView.swift
//
// Created by Andrey Torlopov on 9/4/18.
// Copyright (c) 2018 Andrey Torlopov. All rights reserved.
//


import UIKit

class BaseTableViewHeaderFooterView: UITableViewHeaderFooterView {

	var object: Any? {
		didSet {
			didSetObject(object: object)
		}
	}

	internal func didSetObject(object: Any?) {
	}

}

