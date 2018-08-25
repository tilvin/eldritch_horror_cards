import UIKit

extension AuthViewController {
	
	struct Appearence {
		let errorColor: UIColor = UIColor(hexString: "D34747")
		let borderColor: UIColor = UIColor(hexString: "61B1AB")
	}
}

class AuthViewController: BaseViewController {
	@IBOutlet private var emailTextField: UITextField!
	@IBOutlet private var passwordTextField: UITextField!
	@IBOutlet private var emailView: UIView!
	@IBOutlet private var passwordView: UIView!
	@IBOutlet private var avatarImageView: UIImageView!
	@IBOutlet private var singinButton: UIButton!
	private var appearence = Appearence()
	private var authProvider: AuthProviderProtocol = DI.providers.resolve(AuthProviderProtocol.self)!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		if authProvider.loadToken() {
			autoLogin()
		}
		else {
			let arrayMail = ["gary@testmail.com", "bonita@testmail.com", "luther@testmail.com"]
			emailTextField.text = arrayMail[Int(arc4random_uniform(UInt32(arrayMail.count)))]
		}
	}
	
	//MARK: - Handlers
	
	@IBAction private func signInAction(_ sender: Any) {
		guard let login = emailTextField.text, !login.isEmpty else {
			emailView.borderColor = appearence.errorColor
			emailView.shake()
			return
		}
		
		guard let password = passwordTextField.text, !password.isEmpty else {
			passwordView.borderColor = appearence.errorColor
			passwordView.shake()
			return
		}
		
		passwordView.borderColor = appearence.borderColor
		emailView.borderColor = appearence.borderColor
		authProvider.load(with: login) { (success) in
			success ? print("Users is load!") : print("Something gone wrong!")
		}
		authProvider.authorize(with: login, password: password) { [weak self] (result: Bool) in
			if result {
				let controller = MainViewController()
				controller.modalTransitionStyle = .crossDissolve
				self?.appNavigator?.go(controller: controller, mode: .replace)
			}
		}
	}
	
	@IBAction private func loginChanged(_ sender: UITextField) {
		passwordView.borderColor = appearence.borderColor
		emailView.borderColor = appearence.borderColor
		
		if emailView.tag == 0 {
			checkLogin(login: emailTextField.text ?? "")
		}
	}
	
	private func checkLogin(login: String = "") {
		//FIXME: Тут сложней схема. На сервер отправляется запрос с логином. По которому идет проверка и если такой пользователь есть - возаращется просто урл на его аватар. а дальше идет загрузка аватарки
		if let avatar = UserDefaults.standard.data(forKey: "avatar") {
			guard let image  = UIImage(data: avatar) else {return}
			avatarImageView.set(image: image)
		}
	}
	
	private func autoLogin() {
		guard let login = UserDefaults.standard.string(forKey: "login") else { return }
		singinButton.isEnabled = false
		checkLogin(login: login)
		authProvider.load(with: login) { (success) in
			success ? print("Users is load!") : print("Something gone wrong!")
		}
		emailTextField.typeOn(string: login) { [weak self] in
			self?.passwordTextField.typeOn(string: "*********") {
				delay(seconds: 1.5, completion: {
					let controller = MainViewController()
					controller.modalTransitionStyle = .crossDissolve
					self?.appNavigator?.go(controller: controller, mode: .replace)
				})
			}
		}
	}
}
