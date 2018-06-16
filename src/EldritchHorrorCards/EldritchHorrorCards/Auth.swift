struct Auth {
    private static var _token: String = ""
    private static var _login: String = ""
    
    static var isAuthorized: Bool {
        return !token.isEmpty
    }
    
    static var token: String {
        return _token
    }
    
    static var login: String {
        return _login
    }
    
    static func logout(error: Swift.Error? = nil) {
        Auth.clear()
        Log.writeLog(logLevel: .debug, message: "show auth view controller")
        Router.presentAuth()
    }
    
    static func clear() {
        Auth._token = ""
        ROConfig.set(token: "")
        ROConfig.set(login: "")
        ROConfig.save()
    }
}

extension Auth {
    
    static func start(completion: @escaping (Bool) -> Void) {
        guard !ROConfig.token.isEmpty else {
            completion(false)
            return
        }
        Auth._token = ROConfig.token
        Auth._login = ROConfig.login
        APIRequest.authorization = self
        completion(!ROConfig.login.isEmpty && !ROConfig.token.isEmpty)
    }
    
    static func authorize(with login: String,
                          password: String,
                          completion: @escaping (Bool) -> Void) {
        NetworkManager.getToken(connector: .signin(login: login, password: password)) { (token) in
            Auth._token = token
            Auth._login = login
            ROConfig.set(token: token)
            ROConfig.set(login: login)
            ROConfig.save()
            APIRequest.authorization = self
            completion(true)
        }
    }
}

extension Auth {
    
    enum Error: Swift.Error {
        case cancelled
        case needAuthorize
    }
}

extension Auth: AuthorizationProtocol { }
