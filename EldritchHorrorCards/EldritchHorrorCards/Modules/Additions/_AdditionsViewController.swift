//import UIKit
//
//class AdditionsViewController: BaseViewController {
//	@IBOutlet private var tableView: UITableView!
//	
//	private var selectedIndexPaths: [IndexPath] = []
//	private var additionProvider = DI.providers.resolve(AdditionDataProviderProtocol.self)!
//	private var additions: [Addition] = []
//	private var rowBuilder: RowBuilder!
//
//	//MARK: - Lifecycle
//	
//	init() {
//		super.init(nibName: nil, bundle: nil)
//		self.modalPresentationStyle = .fullScreen
//		self.isHiddenNavigationBar = true
//	}
//	
//	required init?(coder aDecoder: NSCoder) {
//		fatalError("init(coder:) has not been implemented")
//	}
//	
//	override func loadView() {
//		let viewModel = AdditionsViewModel()
//		let view = AdditionsView(frame: UIScreen.main.bounds, viewModel: viewModel)
//		view.delegate = self
//		self.view = view
//	}
//	
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		additionProvider.load() { [weak self] (success) in
//			guard let sSelf = self else { return }
//			sSelf.additions = sSelf.additionProvider.additions
//			sSelf.makeRows()
//		}
//		makeRows()
//	}
//	
//	private func makeRows() {
//		rowBuilder = TableRowBuilder<Addition, AdditionCell>(items: additions)
//		tableView.reloadData()
//	}
//	
//	//MARK: - Handlers
//	
//	@IBAction private func mapButtonPressed(_ sender: Any, forEvent event: UIEvent) {
//		guard let point = event.allTouches?.first?.location(in: tableView) else { return }
//		let path = tableView.indexPathForRow(at: point)!
//		additions[path.row].isSelectedMap.toggle()
//		let cell = tableView.cellForRow(at: path) as! AdditionCell
//		cell.mapButton.alpha = additions[path.row].isSelectedMap ? 1 : 0.5
//		
//		if !selectedIndexPaths.contains(path) {
//			tableView.selectRow(at: path, animated: true, scrollPosition: .none)
//		}
//	}
//
//	@IBAction private func descriptionButtonPressed(_ sender: Any, forEvent event: UIEvent) {
//		guard let point = event.allTouches?.first?.location(in: tableView) else { return }
//		let path = self.tableView.indexPathForRow(at: point)!
//		print(additions[path.row].description)
//		let controller = AdditionDescriptionViewController.controllerFromStoryboard(.additions)
//		controller.modalTransitionStyle = .crossDissolve
//		controller.additionDescription = additions[path.row].description
//		appNavigator?.go(controller: controller, mode: .modal)
//	}
//}
//
////MARK:- UITableViewDataSource
//
//extension AdditionsViewController: UITableViewDataSource  {
//	
//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		return rowBuilder.count
//	}
//	
//	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let cell = tableView.dequeueReusableCell(withIdentifier: rowBuilder.reusableID, for: indexPath)
//		rowBuilder.configure(cell: cell, itemIndex: indexPath.row)
//		return cell
//	}
//}
//
////MARK:- UITableViewDelegate
//
//extension AdditionsViewController: UITableViewDelegate {
//	
//	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		selectedIndexPaths = tableView.indexPathsForSelectedRows ?? []
//		print(selectedIndexPaths)
//	}
//	
//	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//		selectedIndexPaths = tableView.indexPathsForSelectedRows ?? []
//		additions[indexPath.row].isSelectedMap = false
//		tableView.reloadRows(at: [indexPath], with: .fade)
//		print(selectedIndexPaths)
//	}
//}
//
//extension AdditionsViewController: AdditionsViewDelegate {
//	
//}
