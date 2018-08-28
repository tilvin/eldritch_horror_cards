import UIKit

class DescriptionViewController: BaseViewController {
	private var model: Description!
	
	init(with model: Description) {
		super.init(nibName: nil, bundle: nil)
		self.isHiddenNavigationBar = true
		self.model = model
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let view = DescriptionView(frame: UIScreen.main.bounds, viewModel: model)
		self.view = view
		view.delegate = self
	}
}

extension DescriptionViewController: DescriptionViewDelegate {
	
	func backButtonTap() {
		close()
	}
}
