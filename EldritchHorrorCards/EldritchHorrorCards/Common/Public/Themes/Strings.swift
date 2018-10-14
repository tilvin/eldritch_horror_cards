import Foundation

extension String {
	
	enum Strings: String {
		case authError
		case ok
	}
	
	//MARK: - Inits
	
	init(_ localized: Strings) {
		self.init(localized.rawValue.localized)
	}
}

