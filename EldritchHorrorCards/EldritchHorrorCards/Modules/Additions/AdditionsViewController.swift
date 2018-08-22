import UIKit

class AdditionsViewController: BaseViewController {
	var customView: AdditionsListView { return self.view as! AdditionsListView }
	var adapter = AdditionsListTableAdapter()
	
	// MARK: - View lifecycle
	
	override func loadView() {
		let view = AdditionsListView(frame: UIScreen.main.bounds)
		self.view = view
		adapter.delegate = self
		adapter.load(tableView: view.tableView)
		isHiddenNavigationBar = true
	}
}

extension AdditionsViewController: AdditionsListTableAdapterDelegate {

	func didTapInfo(with model: Addition) {
		let controller = AdditionDescriptionViewController(with: model)
		appNavigator?.go(controller: controller, mode: .push)
	}
}
