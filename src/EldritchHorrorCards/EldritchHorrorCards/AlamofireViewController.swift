//import Alamofire
//
//extension UIViewController {
//  
//  static private var onlineCheckInterval = 2.0
//  
//  @objc func buttonPressed(_ sender: UIButton!) {
//    self.checkOnline()
//  }
//  
//  func checkOnline() {
//    let isOnline = NetworkReachabilityManager()!.isReachable
//    
//    guard isOnline else {
//      UIViewController.onlineCheckInterval = UIViewController.onlineCheckInterval < 32 ? UIViewController.onlineCheckInterval * 2 : 32
//      delay(seconds: UIViewController.onlineCheckInterval) { [weak self] in
//        self?.checkOnline()
//      }
//
//      if self.view.subviews.filter({ (view) -> Bool in
//        return view.tag == 1000 || view.tag == 1001
//      }).count == 0 {
//        let imageView = UIImageView(frame: self.view.frame)
//        imageView.image = UIImage(view: self.view).noir
//        imageView.tag = 1000
//        
//        let button = UIButton(frame: self.view.frame)
//        button.setTitle(nil, for: .normal)
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        button.tag = 1001
//        
//        self.view.addSubview(imageView)
//        self.view.addSubview(button)
//      }
//      return
//    }
//    
//    self.view.subviews
//      .filter { $0.tag == 1000 || $0.tag == 1001 }
//      .forEach { $0.removeFromSuperview() }
//    
//    UIViewController.onlineCheckInterval = 2
//    delay(seconds: UIViewController.onlineCheckInterval) { [weak self] in
//      self?.checkOnline()
//    }
//  }
//}
