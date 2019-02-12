//
//  TableSectionConfiguration.swift
//
// Created by Andrey Torlopov on 9/4/18.
// Copyright (c) 2018 Andrey Torlopov. All rights reserved.
//


import UIKit

protocol TableSectionConfigurationProtocol {
	var headerConfiguration: TableViewHeaderFooterConfigurationProtocol {get set}
	var footerConfiguration: TableViewHeaderFooterConfigurationProtocol {get set}
	var cellConfigurations: [TableCellConfigurationProtocol] {get set}
}

class TableSectionConfiguration: TableSectionConfigurationProtocol {

	var headerConfiguration: TableViewHeaderFooterConfigurationProtocol = TableViewHeaderFooterConfiguration()
	var footerConfiguration: TableViewHeaderFooterConfigurationProtocol = TableViewHeaderFooterConfiguration()
	var cellConfigurations: [TableCellConfigurationProtocol] = []

}

