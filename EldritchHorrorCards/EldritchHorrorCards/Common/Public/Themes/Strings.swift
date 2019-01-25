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
		case empty
		case error
		case unknownError
		case online
		case offline
		case loadMonsterError
		case cantSelectAncient
		case cantLoadCards
		case errorMessageTemplate
		case errorNoData
		case turnHistory
		case expeditionCurrentLocation
		case logout
		case additionsTitle
		case additionsButton
		case gameInitError
		case additionContinueButtonError
		case newGame
		case newGameAlert
		case callMonster
	}
	
	//MARK: - Inits
	
	init(_ localized: Strings) {
		self.init(localized.rawValue.localized)
	}
}

