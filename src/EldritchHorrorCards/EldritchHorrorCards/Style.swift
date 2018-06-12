struct Style {
  static var `default`: StyleDef!
  
  static func setup() {
    guard let style = JSONParser<StyleDef>.parse(jsonType: .style) else {
      fatalError("Style file with Error!!!")
    }
    Style.default = style
  }
}

struct StyleDef: Codable {
  struct Account: Codable {
    let solid: String
    let gradientStart: String
    let gradientEnd: String
  }
  
  struct Expense: Codable {
    let solid: String
    let gradientStart: String
    let gradientEnd: String
  }
  
  struct Income: Codable {
    let solid: String
    let gradientStart: String
    let gradientEnd: String
  }
  
  struct DarkBlue: Codable {
    let solid: String
    let gradientStart: String
    let gradientEnd: String
  }
  
  struct Blue: Codable {
    let solid: String
    let gradientStart: String
    let gradientEnd: String
  }
  
  struct TableView: Codable {
    let headerBackground: String
    let transactionCell: TransactionCell
  }
  
  struct TransactionCell: Codable {
    let info: String
    let edit: String
    let delete: String
  }
  
  struct Tabs: Codable {
    let textColorActive: String
    let textColorInactive: String
  }
  
  struct StatusBar: Codable {
    let auth: String
    let main: String
    let menu: String
    let profile: String
    let charts: String
    let chartsFilter: String
    let categories: String
    let transfer: String
    let transactions: String
    let transaction: String
    let accounts: String
    let dictionary: String
  }
  
  var account: Account
  var income: Income
  var expense: Expense
  var darkBlue: DarkBlue
  var blue: Blue
  var gray: String
  var lightGray: String
  var tableView: TableView
  var tabs: Tabs
  var statusBar: StatusBar
}

