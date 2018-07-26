struct LoggerConsole: LoggerProfile {
  let loggerProfileId: String = "logger.console"
  func writeLog(level: String, message: String) {
    let now = getCurrentDateString()
    print(">> \(now): \(level) - \(message)")
  }
}
