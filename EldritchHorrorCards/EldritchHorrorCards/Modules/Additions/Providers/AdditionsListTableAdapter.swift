import UIKit

protocol AdditionsListTableAdapterDelegate: class {
	func didTapInfo(with model: Addition)
	func update(with model: Addition)
}

final class AdditionsListTableAdapter: StaticTableAdapter {
	
	weak var delegate: AdditionsListTableAdapterDelegate?

	func load(tableView: UITableView) {
		connect(tableView: tableView)
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 100
		tableView.tableFooterView = UIView()
		tableView.separatorInset = .zero
		tableView.separatorStyle = UITableViewCellSeparatorStyle.none
		tableView.allowsSelection = false
		registerCell(items: [String(describing: AdditionCell.self): AdditionCell.self])
		configure(with: [])
	}
	
	func configure(with models: [Addition]) {
		let section = TableSectionConfiguration()
		section.headerConfiguration.height = 0
		section.footerConfiguration.height = 0
		
		for model in models {
			let config = TableCellConfiguration.init("\(AdditionCell.self)", instance: AdditionCell.self, configureBlock: { (cell, _) in
				cell.update(with: model)
				cell.delegate = self
			}, actionBlock: { [weak self] (cell, _) in
				self?.delegate?.didTapInfo(with: cell.model)
			})
			section.cellConfigurations.append(config)
		}
		
		setSections([section])
	}
}

extension AdditionsListTableAdapter: AdditionCellDelegate {
 
	func update(with model: Addition) {
		delegate?.update(with: model)
	}
	
	func infoPressed(with model: Addition) {
		delegate?.didTapInfo(with: model)
	}
}
