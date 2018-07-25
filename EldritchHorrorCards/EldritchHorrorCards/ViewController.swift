import UIKit

extension UIViewController {
  
  @IBAction public func dismiss() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction public func pop() {
    _ = self.navigationController?.popViewController(animated: true)
  }
  
  @IBAction public func close() {
    if self.navigationController != nil {
      self.pop()
    }
    else {
      self.dismiss()
    }
  }
  
  @IBAction public func hideKeyboard() {
    self.view.endEditing(true)
  }
}

extension UITabBarController {
  
  override public func close() {
    self.viewControllers?.forEach { (c) in
      if let nav = c as? UINavigationController {
        nav.popToRootViewController(animated: false)
      }
      c.presentedViewController?.dismiss()
    }
  }
}
