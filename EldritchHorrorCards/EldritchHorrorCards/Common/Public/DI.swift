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
		container.register(UserDefaultsDataStoreProtocol.self) { UserDefaultsDataStore() }
		container.register(NavigatorProtocol.self, asSingleTone: true) { AppNavigator()  }
		container.register(ConfigProviderProtocol.self, asSingleTone: true) { ConfigProvider() }
		container.register(AuthProviderProtocol.self, asSingleTone: true) { AuthProvider() }
		container.register(MonsterDataProviderProtocol.self, asSingleTone: true) { MonsterDataProvider() }
		container.register(CardDataProviderProtocol.self, asSingleTone: true) { CardDataProvider() }
		container.register(AdditionDataProviderProtocol.self, asSingleTone: true) { AdditionDataProvider() }
		container.register(GameDataProviderProtocol.self, asSingleTone: true) { GameDataProvider() }
		container.register(TabBarControllersProviderProtocol.self, asSingleTone: true) { TabBarControllersProvider() }
		container.register(DataParseServiceProtocol.self) { DataParseService() }
		container.register(NetworkServiceProtocol.self, asSingleTone: true) { NetworkService() }
		container.register(ExpeditionDataProviderProtocol.self, asSingleTone: true) { ExpeditionDataProvider() }
	}
}
