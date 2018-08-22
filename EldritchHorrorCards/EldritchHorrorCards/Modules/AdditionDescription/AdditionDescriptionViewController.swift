import UIKit

class AdditionDescriptionViewController: BaseViewController {
	private var model: Addition!
	
	init(with model: Addition) {
		super.init(nibName: nil, bundle: nil)
		self.isHiddenNavigationBar = true
		self.model = model
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let view = AdditionDescriptionView(frame: UIScreen.main.bounds, viewModel: model)
		self.view = view
		view.delegate = self
	}
}

extension AdditionDescriptionViewController: AdditionDescriptionViewDelegate {
	
	func backButtonTap() {
		close()
	}
}
