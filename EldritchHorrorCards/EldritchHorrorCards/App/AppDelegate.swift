import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\n\(documentsPath)\n")
        IQKeyboardManager.shared.enable = true
        DI.registerProviders()
        DI.providers.resolve(ConfigProviderProtocol.self)!.load()
        DI.providers.resolve(NavigatorProtocol.self)?.create(self)
		
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
