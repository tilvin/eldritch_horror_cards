import IQKeyboardManagerSwift
import Fabric
import Crashlytics
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Log.addLogProfileToAllLevels(defaultLoggerProfile: LoggerConsole())
    IQKeyboardManager.shared.enable = true
    Fabric.with([Crashlytics.self])
    Style.setup()
    
    var config = Realm.Configuration.defaultConfiguration
    config.schemaVersion = 1
    config.deleteRealmIfMigrationNeeded = true
    Realm.Configuration.defaultConfiguration = config
    
    return true
  }

}
