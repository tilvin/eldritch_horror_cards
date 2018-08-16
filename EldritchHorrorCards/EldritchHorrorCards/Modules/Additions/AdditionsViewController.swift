//
//  AdditionsTableViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 09.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class AdditionsViewController: BaseViewController {
	@IBOutlet private var tableView: UITableView!
	var selectedUIDs: [String] = []
	
	private var additionProvider = DI.providers.resolve(AdditionDataProviderProtocol.self)!
	private var additions: [Addition] = []
	private var rowBuilder: RowBuilder!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		additionProvider.load() { [weak self] (success) in
			guard let sSelf = self else { return }
			sSelf.additions = sSelf.additionProvider.additions
			sSelf.makeRows()
		}
	}
	
	private func makeRows() {
		rowBuilder = TableRowBuilder<Addition, AdditionTableViewCell>(items: additions)
		tableView.reloadData()
	}
}

//MARK:- UITableViewDataSource

extension AdditionsViewController: UITableViewDataSource  {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowBuilder.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: rowBuilder.reusableID, for: indexPath)
		rowBuilder.configure(cell: cell, itemIndex: indexPath.row)
		return cell
	}
}

//MARK:- UITableViewDelegate

extension AdditionsViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selectedCell = tableView.cellForRow(at: indexPath)! as? AdditionTableViewCell else {return}
		selectedCell.buttonImageOutlet.alpha = 1
		selectedCell.borderCell.alpha = 1
		selectedCell.borderCell.shadowColor = .clear
		selectedCell.selectionStyle = .none
		guard let indexPaths = tableView.indexPathsForSelectedRows else {
			selectedUIDs = []
			return
		}
		selectedUIDs = indexPaths.map { additions[$0.row].id }
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		guard let selectedCell = tableView.cellForRow(at: indexPath)! as? AdditionTableViewCell else {return}
		selectedCell.buttonImageOutlet.alpha = 0.5
		selectedCell.borderCell.alpha = 0.5
		selectedCell.borderCell.shadowColor = .none
		guard let indexPaths = tableView.indexPathsForSelectedRows else {
			selectedUIDs = []
			return
		}
		selectedUIDs = indexPaths.map { additions[$0.row].id }
	}
}
