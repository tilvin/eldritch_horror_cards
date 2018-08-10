//
//  AdditionsTableViewController.swift
//  EldritchHorrorCards
//
//  Created by Вероника Садовская on 09.08.2018.
//  Copyright © 2018 Andrey Torlopov. All rights reserved.
//

import UIKit

class AdditionsTableViewController: BaseViewController {
	@IBOutlet private var tableView: UITableView!
	
	private var additionProvider = DI.providers.resolve(AdditionDataProviderProtocol.self)!
	private var additions: [Addition] = []
	var additionsList: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		additionProvider.load{ (success) in
			success ? self.additions = self.additionProvider.additions : print("Something gone wrong!")
		}
	}
}

extension AdditionsTableViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return additions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = additions[indexPath.row].name
		cell.detailTextLabel?.text = additions[indexPath.row].description
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		additionsList.append("\(additions[indexPath.row].id)")
		additionsList = Array(Set(additionsList))
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		additionsList = additionsList.filter { $0 != "\(additions[indexPath.row].id)"}
	}
}
