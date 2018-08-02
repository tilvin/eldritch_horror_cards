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
		
		if authProvider.loadToken() { autoLogin() }
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
		
		authProvider.authorize(with: login, password: password) { [weak self] (result: Bool) in
			guard let sSelf = self else { return }
			Log.writeLog(logLevel: .debug, message: "Auth is \(result)")
			if result {
				Router.presentMonsters(parent: sSelf)
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
		//TODO: подгрузиьт аватар по переданному логину
		let emails = ["torlopov.andrey@gmail.com", "t"]
		Log.writeLog(logLevel: .todo, message: "Load avatar image with login: \(login)")
		
		let isShow = emails.contains(login)
		
		if avatarImageView.isHidden != !isShow {
			avatarImageView.image = #imageLiteral(resourceName: "tmp_ava")
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
		guard !authProvider.login.isEmpty else { return }
		let login = authProvider.login
		checkLogin(login: login)
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
