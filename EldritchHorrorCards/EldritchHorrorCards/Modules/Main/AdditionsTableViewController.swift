//
//  AdditionsTableViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 09.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class AdditionsTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var additionTable: UITableView!
	
	private var additionProvider = DI.providers.resolve(AdditionDataProviderProtocol.self)!
	private var additions: [Addition] = []
	private let cellReuseIdentifier = "cell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		additionProvider.load{ (success) in
			success ? print("Users is load!") : print("Something gone wrong!")
		}
		additions = additionProvider.additions
		additionTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
		additionTable.delegate = self
		additionTable.dataSource = self
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return additions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell:UITableViewCell = (additionTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
		cell = UITableViewCell(style: UITableViewCellStyle.subtitle,
							   reuseIdentifier: cellReuseIdentifier)
		cell.textLabel?.text = additions[indexPath.row].name
		cell.detailTextLabel?.text = additions[indexPath.row].description
		cell.detailTextLabel?.numberOfLines = 0
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("You select addition number \(additions[indexPath.row].id).")
	}
}
