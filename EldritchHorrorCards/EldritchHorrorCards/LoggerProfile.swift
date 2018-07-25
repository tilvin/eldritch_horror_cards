import Foundation

protocol LoggerProfile {
  var loggerProfileId: String { get }
  func writeLog(level: String, message: String)
}

extension LoggerProfile {
  func getCurrentDateString() -> String {
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
    return dateFormatter.string(from: date)
  }
}
