import UIKit

extension UIWindow {
  
  static private var _mainStoryboard: String?
  static private(set) var mainStoryboard: String {
    set {
      _mainStoryboard = newValue
    }
    get {
      if _mainStoryboard == nil {
        _mainStoryboard = Bundle.main.infoDictionary?["UIMainStoryboardFile"] as? String
      }
      return _mainStoryboard!
    }
  }
  
  public func set(mainStoryboard: String,
                  animated: Bool = false,
                  condition: ((UIWindow) -> Bool)? = nil,
                  completion: ((UIWindow) -> ())? = nil) {
    let condition = condition ?? { _ in mainStoryboard != UIWindow.mainStoryboard }
    
    guard condition(self) else {
      completion?(self)
      return
    }
    
    UIWindow.mainStoryboard = mainStoryboard
    
    let src = self.rootViewController
    let dst = UIStoryboard(name: mainStoryboard, bundle: nil).instantiateInitialViewController()!
    
    if animated, src?.isViewLoaded == true {
      UIView.transition(from: src!.view,
                        to: dst.view,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        completion: { (finished) in
                          self.rootViewController = dst
                          completion?(self)
      })
    }
    else {
      self.rootViewController = dst
      completion?(self)
    }
  }
  
  public var topRoot: UIViewController? {
    var root = self.rootViewController
    while let r = root?.presentedViewController {
      root = r
    }
    
    return root
  }
}

extension UIWindow {
  
  public func visibleViewController() -> UIViewController? {
    if let rootViewController: UIViewController = self.rootViewController {
      return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
    }
    return nil
  }
  
  public class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
    if let vc = vc as? UINavigationController {
      return UIWindow.getVisibleViewControllerFrom(vc: vc.visibleViewController!)
    } else if let vc = vc as? UITabBarController {
      return UIWindow.getVisibleViewControllerFrom(vc: vc.selectedViewController!)
    } else {
      if let presentedViewController = vc.presentedViewController {
        return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
      } else {
        return vc
      }
    }
  }
}
