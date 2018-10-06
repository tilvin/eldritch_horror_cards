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
	private let gameProvider = DI.providers.resolve(GameDataProviderProtocol.self)!
	
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
		
		
		//FIXME: тут при переходе в окно всегда будет очищаться логин-пароль.
		// c другой стороны, мы не должны затирать логин пароль при первом запуске.
		// это не критичный баг, потом его можно выпилить
//		customView.emailTextField.text = ""
//		customView.passwordTextField.text = ""
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
	
	private func autoLogin() {
		guard let login = UserDefaults.standard.string(forKey: "login") else { return }
		gameProvider.load { [weak self] (success) in
			guard let sSelf = self else { return }
			sSelf.customView.signUpButton.isEnabled = false
			sSelf.checkLogin(login: login)
			sSelf.authProvider.load(with: login) { (success) in
				success ? print("Users is load!") : print("Something gone wrong!")
				sSelf.customView.emailTextField.text = login
				sSelf.customView.passwordTextField.text = "*********"
				if sSelf.gameProvider.isSessionActive {
					let controller = CardViewController.controllerFromStoryboard(.main)
					controller.modalTransitionStyle = .crossDissolve
					sSelf.appNavigator?.go(controller: controller, mode: .modal)
				}
				else {
					sSelf.gameProvider.load(completion: { (_) in
						let controller = AdditionsViewController()
						controller.modalTransitionStyle = .crossDissolve
						sSelf.appNavigator?.go(controller: controller, mode: .replaceWithPush)
					})
				}
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
			guard let sSelf = self else { return }
			if result {
				if sSelf.gameProvider.isSessionActive {
					let controller = CardViewController.controllerFromStoryboard(.main)
					controller.modalTransitionStyle = .crossDissolve
					sSelf.appNavigator?.go(controller: controller, mode: .modal)
				}
				else {
					sSelf.gameProvider.load(completion: { (_) in
						let controller = AdditionsViewController()
						controller.modalTransitionStyle = .crossDissolve
						sSelf.appNavigator?.go(controller: controller, mode: .replaceWithPush)
					})
				}
			}
		}
	}
	
	func signupButtonPressed() {
		print("sign up pressed")
	}
}
