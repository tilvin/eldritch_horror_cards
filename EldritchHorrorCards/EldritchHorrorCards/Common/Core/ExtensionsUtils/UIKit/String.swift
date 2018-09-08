import UIKit

public enum NumberPart {
  case int, float
}

extension String {
  
  public var html2AttributedString: NSAttributedString? {
    do {
      return try NSAttributedString(data: Data(utf8),
                                    options: [.documentType: NSAttributedString.DocumentType.html,
                                              .characterEncoding: String.Encoding.utf8.rawValue],
                                    documentAttributes: nil)
    }
    catch {
      debugPrint("error:", error)
      return  nil
    }
  }
  
  public var html2String: String {
    return html2AttributedString?.string ?? ""
  }
}

//MARK:- Number/Digitals

extension String {
  
  public func numberPartLength(type: NumberPart = .float) -> Int {
    let d = Double(self) ?? 0
    let stringDouble = String(d)
    let i = Int(d)
    
    switch type {
    case .int:
      return String(i).count
    case .float:
      var f: String = ""
      if String(i).count + 1 < stringDouble.count {
        f = String(stringDouble.dropFirst(String(i).count + 1))
      }
      return f.count
    }
  }
}

//MARK:-

extension String {
  
  public var currencySymbol: String {
    let ids = Locale.availableIdentifiers.filter({ (localeID) -> Bool in
      let l = Locale(identifier: localeID)
      return l.currencyCode == self
    })
    guard let id = ids.first,
      let symbol = Locale(identifier: id).currencySymbol else { return self }
    
    return  symbol
  }
}

//MARK:- Date

extension String {
  
  func toDate (format: DateFormatType = .custom("yyyy-MM-dd")) -> Date? {
    return Date(fromString: self, format: format)
  }
}

//MARK:- Double

extension String {
  
  func removingWhitespaces() -> String {
    return components(separatedBy: .whitespaces).joined()
  }
  
  func double() -> Double {
    let formatter = NumberFormatter()
    formatter.decimalSeparator = "."
    return formatter.number(from: self.removingWhitespaces())?.doubleValue ?? 0.0
  }
}

//MARK:- Color

extension String {
  
  var color: UIColor {
    return UIColor(hexString: self)
  }
}
