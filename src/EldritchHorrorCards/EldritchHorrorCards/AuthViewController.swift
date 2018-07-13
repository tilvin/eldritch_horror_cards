import UIKit

extension AuthViewController {
	
	struct Appearence {
		let errorColor: UIColor = UIColor(hexString: "D34747")
		let borderColor: UIColor = UIColor(hexString: "61B1AB")
	}
}

class AuthViewController: UIViewController {
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var emailView: UIView!
    @IBOutlet private var passwordView: UIView!
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet private var singinButton: UIButton!
	
	private var appearence = Appearence()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.start { [weak self] (success) in
            guard let s = self else { return }
            if success {
                s.autoLogin()
            }
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
        
        Auth.authorize(with: login, password: password) { [weak self] (result: Bool) in
            guard let s = self else { return }
            Log.writeLog(logLevel: .debug, message: "Auth is \(result)")
            if result { Router.presentMonsters(parent: s, inputParams: [:]) }
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
        checkLogin(login: Auth.login)
        emailTextField.typeOn(string: Auth.login) { [weak self] in
            guard let s = self else { return }
            s.passwordTextField.typeOn(string: "*********") {
                delay(seconds: 1.5, completion: {
                    Router.presentMonsters(parent: s)
                })
            }
        }
    }
}
