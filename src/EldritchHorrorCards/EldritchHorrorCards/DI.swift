import Foundation

class DI {
	
	static fileprivate let _di = DI()
	
	fileprivate let container = DIContainer()
	
	public static var providers: DIContainer {
		return _di.container
	}
	
	public static func registerProviders() {
		_di.register()
	}
	
	fileprivate func register() {
		container.register(NavigatorProtocol.self, asSingleTone: true) { AppNavigator()  }
		container.register(ConfigProviderProtocol.self, asSingleTone: true) { ConfigProvider() }
		container.register(AuthProviderProtocol.self, asSingleTone: true) { AuthProvider() }
		container.register(MosterDataProviderProtocol.self, asSingleTone: true) { MosterDataProvider() }
	}
}
