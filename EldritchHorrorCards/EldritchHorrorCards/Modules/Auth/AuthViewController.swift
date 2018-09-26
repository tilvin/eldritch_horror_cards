import UIKit

class AuthViewController: BaseViewController {
	
	//MARK: - Public
	
	var customView: AuthView { return self.view as! AuthView }
	
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
	
	//MARK: - Public variables
	
	var notificationTokens: [NotificationToken] = []
	var editableViews: [UIResponder] {
		guard isViewLoaded else { return [] }
		return [self.customView.emailTextField, self.customView.passwordTextField]
	}
	
	//MARK: - Private variables
	
	private var authProvider: AuthProviderProtocol = DI.providers.resolve(AuthProviderProtocol.self)!
	private var gameProvider: GameDataProviderProtocol = DI.providers.resolve(GameDataProviderProtocol.self)!
	//MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		customView.passwordTextField.isSecureTextEntry = true
		let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:)))
		view.addGestureRecognizer(tap)
		
		if authProvider.loadToken() {
			autoLogin()
		}
		else {
			let arrayMail = ["gary@testmail.com", "bonita@testmail.com", "luther@testmail.com"]
			customView.emailTextField.text = arrayMail[Int(arc4random_uniform(UInt32(arrayMail.count)))]
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
	
	override func viewDidDisappear(_ animated: Bool) {
		gameProvider.load { (success) in
			success ? print("Game is load!") : print("Something gone wrong!")
		}
	}
	//MARK: - Handlers
	
//	@IBAction private func loginChanged(_ sender: UITextField) {
//		passwordView.borderColor = appearence.borderColor
//		emailView.borderColor = appearence.borderColor
//
//		if emailView.tag == 0 {
//			checkLogin(login: emailTextField.text ?? "")
//		}
//	}
	
	//MARK: - Private
	
	@objc func dismissKeyboard(sender: UITapGestureRecognizer) {
		guard editableViews.filter({ (responder) -> Bool in
			return responder.isFirstResponder
		}).count > 0 else { return }
		editableViews.forEach { $0.resignFirstResponder() }
	}
	
	private func autoLogin() {
		guard let login = UserDefaults.standard.string(forKey: "login") else { return }
		customView.signUpButton.isEnabled = false
		checkLogin(login: login)
		authProvider.load(with: login) { (success) in
			success ? print("Users is load!") : print("Something gone wrong!")
		}
		customView.emailTextField.typeOn(string: login) { [weak self] in
			self?.customView.passwordTextField.typeOn(string: "*********") {
				delay(seconds: 1, completion: {
					let controller = AdditionsViewController()
					controller.modalTransitionStyle = .crossDissolve
					self?.appNavigator?.go(controller: controller, mode: .replace)
				})
			}
		}
	}
	
	private func checkLogin(login: String = "") {
		//FIXME: Тут сложней схема. На сервер отправляется запрос с логином. По которому идет проверка и если такой пользователь есть - возаращется просто урл на его аватар. а дальше идет загрузка аватарки
		if let avatar = UserDefaults.standard.data(forKey: "avatar") {
			guard let image  = UIImage(data: avatar) else {return}
			customView.avatarView.update(avatar: image)
		}
	}
}

extension AuthViewController: Keyboardable {}

extension AuthViewController: AuthViewDelegate {
	
	func loginButtonPressed() {
		guard let login = customView.emailTextField.text, !login.isEmpty else {
			customView.updateView(type: .email)
			return
		}
		
		guard let password = customView.passwordTextField.text, !password.isEmpty else {
			customView.updateView(type: .password)
			return
		}
		customView.updateView(type: .none)
		authProvider.load(with: login) { (success) in
			success ? print("Users is load!") : print("Something gone wrong!")
		}
		authProvider.authorize(with: login, password: password) { [weak self] (result: Bool) in
			if result {
				let controller = AdditionsViewController()
				controller.modalTransitionStyle = .crossDissolve
				self?.appNavigator?.go(controller: controller, mode: .replace)
			}
		}
	}
	
	func signupButtonPressed() {
		print("sign up pressed")
	}
}
