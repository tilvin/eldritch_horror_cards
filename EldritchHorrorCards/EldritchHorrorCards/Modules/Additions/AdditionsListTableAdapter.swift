import UIKit

protocol AdditionsListTableAdapterDelegate: class {
	func didTapOnCell(with model: Addition)
}

class AdditionsListTableAdapter: StaticTableAdapter {
	weak var delegate: AdditionsListTableAdapterDelegate?
	
	private var provider = DI.providers.resolve(AdditionDataProviderProtocol.self)!
	
	///Perform installing and configuring table view
	///
	/// - Parameter tableView: object for configuring
	func load(tableView: UITableView) {
		connect(tableView: tableView)
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 150
		tableView.tableFooterView = UIView()
		tableView.separatorInset = .zero
		tableView.separatorStyle = UITableViewCellSeparatorStyle.none
		
		registerCell(items: ["\(AdditionCell.self)": AdditionCell.self])

		provider.load { [weak self] (models) in
			self?.configure(with: models)
		}
	}
	
	private func configure(with models: [Addition]) {
		let section = TableSectionConfiguration()
		section.headerConfiguration.height = 0
		section.footerConfiguration.height = 0
		
		for model in models {
			let config = TableCellConfiguration.init("\(AdditionCell.self)", instance: AdditionCell.self, configureBlock: { (cell, _) in
				cell.update(with: model)
			}, actionBlock: { [weak self] (cell, _) in
				self?.delegate?.didTapOnCell(with: cell.model)
			})
			section.cellConfigurations.append(config)
		}
		
		setSections([section])
	}
}
