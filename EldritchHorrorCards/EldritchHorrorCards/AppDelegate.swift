import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		#if DEBUG
		print("debug mode: on!")
		#endif
		
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\n\(documentsPath)\n")
		
		var config = Realm.Configuration.defaultConfiguration
		config.schemaVersion = 1
		config.deleteRealmIfMigrationNeeded = true
		Realm.Configuration.defaultConfiguration = config
		
        DI.registerProviders()
        DI.providers.resolve(ConfigProviderProtocol.self)!.load()
        DI.providers.resolve(NavigatorProtocol.self)?.create(self)
		
		if let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView  {
			statusBarView.backgroundColor = .wildSand
		}
		
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        DI.providers.resolve(ConfigProviderProtocol.self)!.save { (success) in
            if !success {
                debugPrint("Can's save config!")
            }
        }
    }
}
