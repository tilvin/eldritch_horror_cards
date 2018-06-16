import RealmSwift

class Router {
  static var completionKey: String { return "completion" }
  
  static func presentMonsters(parent: UIViewController, inputParams: [String: Any]) {
//    guard let completion = inputParams[Router.completionKey] as? Command,
//      let startIndex = inputParams[TutorialPageController.START_INDEX_KEY] as? Int,
//      let indexesRange = inputParams[TutorialPageController.INDEXES_RANGE_KEY] as? CountableClosedRange<Int> else {
//        Log.writeLog(logLevel: .debug, message: "presentTutorial guard message! \ninputParams: \n\(inputParams)")
//        return
//    }
    
    let controller = MonstersViewController.controllerFromStoryboard(.main)
    let nc = UINavigationController(rootViewController: controller)
    controller.modalTransitionStyle = .crossDissolve
    parent.present(nc, animated: true, completion: nil)
  }
}
