struct Log: Logger {
  static var loggers = [LogLevels : [LoggerProfile]]()
  static func writeLog(logLevel: LogLevels, message: String) {
    guard hasLoggerForLevel(logLevel: logLevel) else {
      print("NO Logger!")
      return
    }
    
    if let logProfiles = loggers[logLevel] {
      logProfiles.forEach { $0.writeLog(level: logLevel.rawValue, message: message) }
    }
  }
}
