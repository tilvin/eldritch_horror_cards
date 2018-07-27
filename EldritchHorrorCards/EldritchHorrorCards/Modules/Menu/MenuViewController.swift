import UIKit

protocol MenuEmbedProtocol: class {
	var menuContainerView: UIView { get}
	var menuAction: CommandWith<Command>! { get set }
	func setupMenu()
}

extension MenuEmbedProtocol where Self: UIViewController {
	
	func setupMenu() {
		let controller = MenuViewController()
		controller.setup(completion: { [weak self] (command) in
			self?.menuAction = command
		})
		menuContainerView.isHidden = true
		menuContainerView.embed(subview: controller.view)
		addChildViewController(controller)
		controller.didMove(toParentViewController: self)
	}
}

final class MenuViewController: BaseViewController {
	private var menuAction: CommandWith<Command>!
	private var setupAction: (() -> Void)?
	private var backgroundTapCmd: Command?
	private var isSlided: Bool = false
	
	
	init() {
		super.init(nibName: nil, bundle: nil)
		self.modalPresentationStyle = .fullScreen
		self.isHiddenNavigationBar = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		let view = MenuView(frame: UIScreen.main.bounds)
		view.delegate = self
		self.view = view
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		menuAction = CommandWith<Command>(action: { [weak self] (cmd) in
			guard let sSelf = self else { return }
			if let vc = sSelf.parent as? MenuEmbedProtocol {
				vc.menuContainerView.isHidden = !vc.menuContainerView.isHidden
			}
			sSelf.backgroundTapCmd = cmd
			sSelf.set(slided: !sSelf.isSlided, animated: true)
			
		})
		setupAction?()
		
		set(slided: isSlided)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	
	func setup(completion: @escaping (CommandWith<Command>) -> Void) {
		setupAction = { [weak self] in
			completion((self?.menuAction)!)
		}
	}
	
	fileprivate func set(slided: Bool, animated: Bool = false, prepareToStart: Bool = true) {
		guard let menuView = self.view as? MenuView else { return }
		isSlided = slided
		menuView.contentView.superview?.isHidden = false
		if prepareToStart {
			menuView.contentView.frame.origin.x = slided ? -menuView.contentView.frame.width : -40
			menuView.alpha = !slided ? 0 : 1
		}
		
		let animations = {
			menuView.contentView.frame.origin.x = !slided ? -menuView.contentView.frame.width : -40
			menuView.alpha = slided ? 1 : 0
		}
		
		let completion: (Bool) -> Void = { [weak self] _ in
			guard let sSelf = self else { return }
			menuView.contentView.superview?.isHidden = !slided
			if let vc = sSelf.parent as? MenuEmbedProtocol {
				vc.menuContainerView.isHidden = !slided
			}
			if slided {
				sSelf.reloadMenu()
			}
		}
		
		if animated {
			UIView.animate(withDuration: 0.7,
						   delay: 0.0,
						   usingSpringWithDamping: 0.5,
						   initialSpringVelocity: 0.0,
						   options: .curveEaseInOut, animations: animations, completion: completion)
			
			if slided {
				UIView.animate(withDuration: 0.25,
							   delay: 0.3,
							   options: .curveLinear,
							   animations: {
								menuView.contentView.frame.origin.x = 0
				}, completion: nil)
			}
		} else {
			animations()
			if slided { menuView.contentView.frame.origin.x = 0 }
			completion(false)
		}
	}
	
	
}

extension MenuViewController {
	
	private func reloadMenu() {
		Log.writeLog(logLevel: .debug, message: "Reload menu method!")
	}
}

extension MenuViewController: MenuViewDelegate {
	
	func backgroundTap() {
		set(slided: false, animated: true, prepareToStart: false)
	}
}
