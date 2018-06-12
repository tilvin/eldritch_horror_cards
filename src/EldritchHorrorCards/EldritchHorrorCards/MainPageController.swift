import UIKit

class MainPageController: BaseViewController, UIPageViewControllerDelegate {
  var pageViewController: UIPageViewController?
  var _modelController: MainPageModelController? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                   navigationOrientation: .horizontal, options: nil)
    pageViewController!.delegate = self
    let startingViewController: UIViewController = modelController.viewControllerAtIndex(0)!
    let viewControllers = [startingViewController]
    pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })
    pageViewController!.dataSource = modelController
    
    addChildViewController(pageViewController!)
    view.addSubview(pageViewController!.view)
    
    var pageViewRect = view.bounds
    if UIDevice.current.userInterfaceIdiom == .pad {
      pageViewRect = pageViewRect.insetBy(dx: 40.0, dy: 40.0)
    }
    pageViewController!.view.frame = pageViewRect
    pageViewController!.didMove(toParentViewController: self)
  }
  
  var modelController: MainPageModelController {
    if _modelController == nil { _modelController = MainPageModelController() }
    
    return _modelController!
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
    if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
      let currentViewController = pageViewController.viewControllers![0]
      let viewControllers = [currentViewController]
      pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
      
      pageViewController.isDoubleSided = false
      return .min
    }
    
    let currentViewController = pageViewController.viewControllers![0] as! MainViewController
    var viewControllers: [UIViewController]
    let indexOfCurrentViewController = modelController.indexOfViewController(currentViewController)
    
    if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
      let nextViewController = modelController.pageViewController(pageViewController, viewControllerAfter: currentViewController)
      
      viewControllers = [currentViewController, nextViewController!]
    } else {
      let previousViewController = modelController.pageViewController(pageViewController, viewControllerBefore: currentViewController)
      viewControllers = [previousViewController!, currentViewController]
    }
    self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
    
    return .mid
  }
}
