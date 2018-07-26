import RealmSwift

protocol ConfigProtocol {
	var token: String { get set }
	var login: String { get set }
}

struct Config: ConfigProtocol {
	var token: String = ""
	var login: String = ""
}

extension Config: Persistable {

	public init(managedObject: ROConfig) {
		token = managedObject.tokenKey
		login = managedObject.loginKey
	}

	public func managedObject() -> ROConfig {
		let object = ROConfig()
		object.tokenKey = token
		object.loginKey = login
		
		return object
	}
}
