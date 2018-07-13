import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Log.addLogProfileToAllLevels(defaultLoggerProfile: LoggerConsole())
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        Log.writeLog(logLevel: .info, message: "\n\(documentsPath)\n")
        IQKeyboardManager.shared.enable = true
        Fabric.with([Crashlytics.self])
        
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 1
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
		
        DI.registerProviders()
		DI.providers.resolve(ConfigProviderProtocol.self)!.load()
		
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
		DI.providers.resolve(ConfigProviderProtocol.self)!.save { (success) in
			if !success {
				//TODO: Отправлять данные в Crashlytics!
				debugPrint("Can's save config!")
			}
		}
    }
}
