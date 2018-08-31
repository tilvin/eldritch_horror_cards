import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\n\(documentsPath)\n")
		
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
