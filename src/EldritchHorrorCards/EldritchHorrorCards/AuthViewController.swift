class AuthViewController: UIViewController {
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var emailView: UIView!
    @IBOutlet private var passwordView: UIView!
    @IBOutlet private var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Handlers
    
    @IBAction private func authTap(_ sender: Any) {
        guard let login = emailTextField.text, !login.isEmpty else {
            emailView.borderColor = Style.default.error.color
            emailView.shake()
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordView.borderColor = Style.default.error.color
            passwordView.shake()
            return
        }
        
        passwordView.borderColor = Style.default.mainGreen.solid.color
        emailView.borderColor = Style.default.mainGreen.solid.color
        
        print(login, password)
        Router.presentMonsters(parent: self, inputParams: [:])
    }
    
    @IBAction private func loginChanged(_ sender: UITextField) {
        passwordView.borderColor = Style.default.mainGreen.solid.color
        emailView.borderColor = Style.default.mainGreen.solid.color
     
        if emailView.tag == 0 {
            avatarImageView.image = #imageLiteral(resourceName: "tmp_ava")
            self.avatarImageView.alpha = sender.text == "torlopov.andrey@gmail.com" ? 0: 1
            UIView.animate(withDuration: 1.0,
                           animations: {
                            self.avatarImageView.alpha = sender.text == "torlopov.andrey@gmail.com" ? 1: 0
            }) { (success) in
                self.avatarImageView.isHidden = sender.text != "torlopov.andrey@gmail.com"
            }
            
            print("check email! \(sender.text)")
        }
    }
}
