class BaseViewController: UIViewController {
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIViewController.setStatusbar(with: self.statusBarColor())
    UIApplication.shared.statusBarStyle = self.isLightStatusFont ? .lightContent : .default
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    UIApplication.shared.statusBarStyle = .lightContent
  }
  
  override var preferredStatusBarStyle : UIStatusBarStyle { return self.isLightStatusFont ? .lightContent : .default }
  
  private func statusBarColor() -> UIColor {
    return .gray
//    guard let identifier = self.restorationIdentifier else { return Style.default.statusBar.auth.color }
//    switch identifier {
//    case "AuthViewController", "TutorialLoaderViewController", "TutorialPageController", "TutorialViewController": return Style.default.statusBar.auth.color
//    case "ChartsViewController": return Style.default.statusBar.charts.color
//    case "ChartFiltersViewController": return Style.default.statusBar.chartsFilter.color
//    case "AccountsViewController", "AccountViewController": return Style.default.statusBar.accounts.color
//    case "CategoriesViewController", "CategoryViewController": return Style.default.statusBar.categories.color
//    case "DictionaryViewController", "CurrencyDictionaryViewController": return Style.default.statusBar.dictionary.color
//    case "MenuViewController", "ProfileViewController", "SettingsViewController": return Style.default.statusBar.menu.color
//    case "TransactionsViewController": return Style.default.statusBar.transactions.color
//    case "TransactionViewController": return Style.default.statusBar.transaction.color
//    case "TransferViewController": return Style.default.statusBar.transfer.color
//    case "MainPageController", "MainViewController": return Style.default.statusBar.main.color
//    default:
//    return Style.default.statusBar.auth.color
//    }
  }
  
  private var isLightStatusFont: Bool {
    guard let identifier = self.restorationIdentifier else { return true }
    switch identifier {
    case "AuthViewController", "TutorialLoaderViewController", "TutorialPageController", "TutorialViewController":
      return false
    default:
      return true
    }
  }
}
