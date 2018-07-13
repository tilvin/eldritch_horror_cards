struct Auth {
    private static var _token: String = ""
    private static var _login: String = ""
	private static var configService = DI.providers.resolve(ConfigProviderProtocol.self)!
	
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
		configService.config.token = ""
		configService.config.login = ""
		configService.save(completion: nil)
    }
}

extension Auth {
    
    static func start(completion: @escaping (Bool) -> Void) {
        guard !configService.config.token.isEmpty else {
            completion(false)
            return
        }
        Auth._token = configService.config.token
        Auth._login = configService.config.login
        completion(!configService.config.login.isEmpty && !configService.config.token.isEmpty)
    }
    
    static func authorize(with login: String,
                          password: String,
                          completion: @escaping (Bool) -> Void) {
        NetworkManager.getToken() { (token) in
            Auth._token = token
            Auth._login = login
            configService.config.token = token
            configService.config.login = login
			configService.save(completion: { (success) in
				completion(success)
			})
        }
    }
}

extension Auth {
    
    enum Error: Swift.Error {
        case cancelled
        case needAuthorize
    }
}
