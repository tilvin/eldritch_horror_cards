import RealmSwift

class ROConfig: Object {
    private static let TOKEN_KEY = "TOKEN_KEY"
    private static let LOGIN_KEY = "LOGIN_KEY"
    
    @objc dynamic var _tokenKey: String = ""
    @objc dynamic var _loginKey: String = ""
    
    private static var `default`: [String: Any] = [:]
    
    static func setup() {
        let realm = try! Realm()
        let configs = realm.objects(ROConfig.self)
        if configs.count == 0  {
            let config = ROConfig()
            try! realm.write { realm.add(config) }
        }
        
        if let config = configs.first {
            ROConfig.default[TOKEN_KEY] = config._tokenKey
            ROConfig.default[LOGIN_KEY] = config._loginKey
        } else {
            fatalError()
        }
    }
    
    static func save() {
        let realm = try! Realm()
        guard let config = realm.objects(ROConfig.self).first else {
            try! realm.write { realm.add(ROConfig()) }
            return
        }
        
        guard let token = ROConfig.default[TOKEN_KEY] as? String,
            let login = ROConfig.default[LOGIN_KEY] as? String else {
                try! realm.write { realm.add(ROConfig()) }
                return
        }
        
        try! realm.write {
            config._tokenKey = token
            config._loginKey = login
        }
    }
}

//MARK: - Getters

extension ROConfig {
    
    static var token: String {
        guard let value = ROConfig.default[TOKEN_KEY] as? String else { fatalError() }
        return value
    }
    
    static var login: String {
        guard let value = ROConfig.default[LOGIN_KEY] as? String else { fatalError() }
        return value
    }
}

//MARK: - Setters

extension ROConfig {
    
    static func set(token: String) { ROConfig.default[TOKEN_KEY] = token }
    static func set(login: String) { ROConfig.default[LOGIN_KEY] = login }
}
