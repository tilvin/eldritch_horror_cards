import Foundation

extension String {
	
	enum Strings: String {
		case authError
		case ok
		case email
		case password
		case authSignup
		case authSignin
		case authTitle
		case gameOverAlert
		case warning
		case cancel
	}
	
	//MARK: - Inits
	
	init(_ localized: Strings) {
		self.init(localized.rawValue.localized)
	}
}

