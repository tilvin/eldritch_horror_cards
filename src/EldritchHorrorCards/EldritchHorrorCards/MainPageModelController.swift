class MainPageModelController: NSObject, UIPageViewControllerDataSource {
  
  enum MainPageType: String {
    case main = "MainViewController"
    case tmp = "CheckViewController"
  }
  
  var pageType: [MainPageType] = [.main, .tmp]
  var currentPage: MainPageType = .main
  var controllerCash: [MainPageType: UIViewController] = [:]

  func viewControllerAtIndex(_ index: Int) -> UIViewController? {
    guard 0...pageType.count ~= index else { return nil }
    
    if controllerCash.count == 0 {
      let mainVC = MainViewController.controllerFromStoryboard(.main)
      controllerCash[.main] = mainVC
      let tmp = CheckViewController.controllerFromStoryboard(.main)
      controllerCash[.tmp] = tmp
    }
    
    return controllerCash[pageType[index]]!
  }
  
  func indexOfViewController(_ viewController: UIViewController) -> Int {
    guard let controllerID = viewController.restorationIdentifier,
      let pageType = MainPageType(rawValue: controllerID) else { return NSNotFound }
    currentPage = pageType
    return self.pageType.index(of: pageType) ?? NSNotFound
  }
  
  // MARK: - Page View Controller Data Source
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    var index = indexOfViewController(viewController)
    if (index == 0) || (index == NSNotFound) { return nil }
    index -= 1
    if index < 0 { return nil }
    
    return viewControllerAtIndex(index)
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    var index = indexOfViewController(viewController)
    if index == NSNotFound { return nil }
    
    index += 1
    if index == pageType.count { return nil }
    
    return viewControllerAtIndex(index)
  }
}
