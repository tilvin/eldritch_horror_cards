import UIKit

final class AuthViewController: BaseViewController {
	var customView: AuthView { return self.view as! AuthView }
	var notificationTokens: [NotificationToken] = []
	var editableViews: [UIResponder] {
		guard isViewLoaded else { return [] }
		return [self.customView.emailTextView.textField, self.customView.passwordTextView.textField]
	}
	
	//MARK: - Private variables
	
	private var gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
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
		
		if let currentUser = authProvider.currentUser,
			gameProvider.game.isSessionActive {
			print(currentUser)
			print("load session!")
		}
		else {
			if let email = ["torlopov.andrey@testmail.com", "foo@bar.baz"].shuffled().first {
				customView.update(textFieldType: .email, text: email, state: .normal)
			}
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		//FIXME: переработать метод. Убрать загрузку gameID из данного контроллера. Это будет делать AdditionalVC.
		showErrorAlert(message: "Need rework!")
		
		registerKeyboardNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		unregisterKeyboardNotifications()
	}
	
	//MARK: - Private
	
	@objc func dismissKeyboard(sender: UITapGestureRecognizer) {
		self.customView.endEditing(true)
	}
	
	private func checkLogin(login: String) {
		authProvider.loadAvatar(login: login) { [weak self] (image) in
			self?.customView.update(avatar: image)
		}
	}
}

extension AuthViewController: Keyboardable {}

extension AuthViewController: AuthViewDelegate {
	
	func loginButtonPressed(login: String, password: String) {
		guard authProvider.allFieldIsValid else {
			Alert(alert: String(.authError), actions: String(.ok)).present(in: self)
			return
		}
		
		authProvider.authorize(with: login, password: password) { [weak self] (result) in
			guard let sSelf = self, result else {
				Alert(alert: String(.authError), actions: String(.ok)).present(in: self)
				return
			}
			
			sSelf.gameProvider.loadGameId(completion: { (_) in
				let controller = AdditionsViewController()
				controller.modalTransitionStyle = .crossDissolve
				sSelf.appNavigator?.go(controller: controller, mode: .replaceWithPush)
			})
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
		
		//FIXME: костыль! надо придумать покрасивше!
		if fieldType == .password {
			checkLogin(login: customView.viewModel.item(type: .email).text)
		}
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
