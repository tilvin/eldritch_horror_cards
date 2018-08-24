import UIKit

class AdditionsViewController: BaseViewController {
	var customView: AdditionsListView { return self.view as! AdditionsListView }
	var adapter = AdditionsListTableAdapter()
	var menuAction: CommandWith<Command>!
	var menuContainerView: UIView { return self.menuContainer }
	
	private lazy var menuButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "menu_button")!, for: .normal)
		button.addTarget(self, action: #selector(AdditionsViewController.menuButtonAction), for: .touchUpInside)
		return button
	}()
	
	lazy var menuContainer: UIView = {
		let view = UIView()
		view.backgroundColor = .clear
		return view
	}()
	
	// MARK: - View lifecycle
	
	override func loadView() {
		let view = AdditionsListView(frame: UIScreen.main.bounds)
		self.view = view
		adapter.delegate = self
		adapter.load(tableView: view.tableView)
		isHiddenNavigationBar = true
		setupMenu()
		addSubViews()
		makeConstraints()
	}
	
	@objc func menuButtonAction(_ sender: UIButton) {
		let reloadCmd = Command {  (_) in
			print("reload view!")
		}
		menuAction?.perform(with: reloadCmd)
	}
	private func addSubViews() {
		view.addSubview(menuButton)
		view.addSubview(menuContainer)
	}
	
	private func makeConstraints() {
		menuContainer.snp.makeConstraints { (make) in
			make.edges.equalToSuperview()
		}
		
		menuButton.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.top.equalToSuperview().inset(28)
			make.width.height.equalTo(70)
		}
	}
}

extension AdditionsViewController: AdditionsListTableAdapterDelegate {
	
	func didTapInfo(with model: Addition) {
		let controller = AdditionDescriptionViewController(with: model)
		appNavigator?.go(controller: controller, mode: .push)
	}
}

extension AdditionsViewController : MenuEmbedProtocol{}
