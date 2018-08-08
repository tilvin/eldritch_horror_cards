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
	private var authProvider: AuthProviderProtocol!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		authProvider = DI.providers.resolve(AuthProviderProtocol.self)!
		if authProvider.loadToken() {
			autoLogin()
		} else {
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
			if success {
				Log.writeLog(logLevel: .debug, message: "Users is load!")
			}
			else {
				Log.writeLog(logLevel: .error, message: "Something gone wrong!")
			}
		}
		authProvider.authorize(with: login, password: password) { [weak self] (result: Bool) in
			Log.writeLog(logLevel: .debug, message: "Auth is \(result)")
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
		Log.writeLog(logLevel: .todo, message: "Load avatar image with login: \(login)")		
		var isShow = false
		if let avatar = UserDefaults.standard.data(forKey: "avatar") {
			isShow = true
			avatarImageView.image = UIImage(data: avatar)
		}
		if avatarImageView.isHidden != !isShow {
			if isShow { avatarImageView.isHidden = false }
			avatarImageView.alpha = isShow ? 0 : 1			
			UIView.animate(withDuration: 1,
						   animations: {
							self.avatarImageView.alpha = isShow ? 1 : 0
			}) { (success) in
				self.avatarImageView.isHidden = !isShow
			}
		}
	}
	
	private func autoLogin() {
		singinButton.isEnabled = false
		Log.writeLog(logLevel: .debug, message: "Authlogin!")
		if let login = UserDefaults.standard.string(forKey: "login") {
			checkLogin(login: login)
			authProvider.load(with: login) { (success) in
				if success {
					Log.writeLog(logLevel: .debug, message: "Users is load!")
				}
				else {
					Log.writeLog(logLevel: .error, message: "Something gone wrong!")
				}
			}
			emailTextField.typeOn(string: login) { [weak self] in
				guard let s = self else { return }
				s.passwordTextField.typeOn(string: "*********") {
					delay(seconds: 1.5, completion: {
						Router.presentMonsters(parent: s)
					})
				}
			}
			
		}
		
	}
}
