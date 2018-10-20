import UIKit

class AuthViewController: BaseViewController {
	var customView: AuthView { return self.view as! AuthView }
	var notificationTokens: [NotificationToken] = []
	var editableViews: [UIResponder] {
		guard isViewLoaded else { return [] }
		return [self.customView.emailTextView.textField, self.customView.passwordTextView.textField]
	}
	
	//MARK: - Private variables
	
	private var gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
	private let cardDataProvider = DI.providers.resolve(CardDataProviderProtocol.self)!
	private var authProvider: AuthProviderProtocol = DI.providers.resolve(AuthProviderProtocol.self)!
	
	// MARK: - Init
	
	init() {
		super.init(nibName: nil, bundle: nil)
		self.isHiddenNavigationBar = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		self.view = AuthView(frame: UIScreen.main.bounds)
		customView.delegate = self
	}
	
	//MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:))))
		if let email = ["torlopov.andrey@testmail.com", "foo@bar.baz"].shuffled().first {
			customView.update(textFieldType: .email, text: email, state: .normal)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		registerKeyboardNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unregisterKeyboardNotifications()
	}
	
	//MARK: - Private
	
	@objc func dismissKeyboard(sender: UITapGestureRecognizer) {
		guard editableViews.filter({ (responder) -> Bool in
			return responder.isFirstResponder
		}).count > 0 else { return }
		editableViews.forEach { $0.resignFirstResponder() }
	}
	
	private func checkLogin(login: String = "") {
		customView.update(avatar: authProvider.avatar)
	}
}

extension AuthViewController: Keyboardable {}

extension AuthViewController: AuthViewDelegate {

	func loginButtonPressed(login: String, password: String) {
		guard authProvider.allFieldIsValid else {
			Alert(alert: String(.authError), actions: String(.ok)).present(in: self)
			return
		}
		if !gameProvider.isSessionActive {
			authProvider.load(with: login) { (success) in
				success ? print("Users is load!") : print("Something gone wrong!")
			}
		}
		authProvider.authorize(with: login, password: password) { [weak self] (result: Bool) in
			guard let sSelf = self else { return }
//			if result {
//				if sSelf.gameProvider.isSessionActive {
//					let controller = CardViewController.controllerFromStoryboard(.main)
//					controller.modalTransitionStyle = .crossDissolve
//					sSelf.appNavigator?.go(controller: controller, mode: .modal)
//				}
//				else {
//					sSelf.gameProvider.load(completion: { (_) in
//						let controller = AdditionsViewController()
//						controller.modalTransitionStyle = .crossDissolve
//						sSelf.appNavigator?.go(controller: controller, mode: .replaceWithPush)
//					})
//				}
//			}
//			else {
//				Alert(alert: String(.authError), actions: String(.ok)).present(in: sSelf)
//			}
		}
	}
	
	func signupButtonPressed() {
		print("sign up pressed")
	}
	
	func validateActiveField(type: AuthTextViewType, text: String) {
		let isValid = authProvider.isValid(type: type, text: text)
		customView.update(textFieldType: type, text: text, state: isValid ? .active : .error)
	}
	
	func beginEditing(fieldType: AuthTextViewType, text: String) {
		authProvider.isValid(type: fieldType, text: text)
		customView.update(textFieldType: fieldType, text: text, state: .active)
	}
	
	func endEditing(fieldType: AuthTextViewType, text: String) {
		let isValid = authProvider.isValid(type: fieldType, text: text)
		customView.update(textFieldType: fieldType, text: text, state: isValid ? .normal : .error)
	}
	
	func valueChanged(fieldType: AuthTextViewType, text: String) {
		authProvider.isValid(type: fieldType, text: text)
		customView.update(textFieldType: fieldType, text: text, state: .active)
	}
}

/*
private func autoLogin() {
guard let login = authProvider.login else { return }
print("autologin...")
//
//		if gameProvider.isSessionActive {
//			self.customView.signUpButton.isEnabled = false
//			self.checkLogin(login: authProvider.login)
//			self.customView.emailTextField.text = authProvider.login
//			self.customView.passwordTextField.text = "*********"
//			cardDataProvider.load(gameId: gameProvider.game.id) { [weak self] (success) in
//				guard let sSelf = self else { return }
//				if success {
//					let controller = CardViewController.controllerFromStoryboard(.main)
//					controller.modalTransitionStyle = .crossDissolve
//					sSelf.appNavigator?.go(controller: controller, mode: .modal)
//				}
//				else {
//					print("error!")
//				}
//			}
//		}
//		else {
//			gameProvider.load { [weak self] (success) in
//				guard let sSelf = self else { return }
//				sSelf.customView.signUpButton.isEnabled = false
//				sSelf.checkLogin(login: login)
//				sSelf.authProvider.load(with: login) { (success) in
//					success ? print("Users is load!") : print("Something gone wrong!")
//					sSelf.customView.emailTextField.text = login
//					sSelf.customView.passwordTextField.text = "*********"
//					if sSelf.gameProvider.isSessionActive {
//						provider.load(gameId: gameProvider.game.id) { [weak self] (success) in
//							guard let sSelf = self else { return }
//							if success {
//								print("Card is load!!")
//								let controller = CardViewController.controllerFromStoryboard(.main)
//								controller.modalTransitionStyle = .crossDissolve
//								sSelf.appNavigator?.go(controller: controller, mode: .modal)
//							}
//							else {
//								print("error!")
//							}
//						}
//					}
//					else {
//						sSelf.gameProvider.load(completion: { (_) in
//							let controller = AdditionsViewController()
//							controller.modalTransitionStyle = .crossDissolve
//							sSelf.appNavigator?.go(controller: controller, mode: .replaceWithPush)
//						})
//					}
//				}
//			}
//		}
}
*/
