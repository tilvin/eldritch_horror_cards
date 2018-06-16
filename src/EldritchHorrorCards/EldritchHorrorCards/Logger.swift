enum LogLevels: String {
  case fatal, error, warn, debug, info, update, todo
  
  static let allValues = [todo, fatal, error, warn, debug, info, update]
}

protocol Logger {
  static var loggers: [LogLevels: [LoggerProfile]] { get set }
  static func writeLog(logLevel: LogLevels, message: String)
}

extension Logger {
  
  static func logLevelContainsProfile(logLevel: LogLevels, loggerProfile: LoggerProfile) -> Bool {
    if let logProfiles = loggers[logLevel] {
      for logProfile in logProfiles where
        logProfile.loggerProfileId == loggerProfile.loggerProfileId {
          return true
      }
    }
    return false
  }
  
  static func setLogLevel(logLevel: LogLevels, loggerProfile: LoggerProfile) {
    
    if let _ = loggers[logLevel] {
      if !logLevelContainsProfile(logLevel: logLevel, loggerProfile: loggerProfile) {
        loggers[logLevel]?.append(loggerProfile)
      }
    } else {
      var a = [LoggerProfile]()
      a.append(loggerProfile)
      loggers[logLevel] = a
    }
  }
  
  static func addLogProfileToAllLevels(defaultLoggerProfile: LoggerProfile) {
    for level in LogLevels.allValues {
      setLogLevel(logLevel: level, loggerProfile: defaultLoggerProfile)
    }
  }
  
  static func removeLogProfileFromLevel(logLevel: LogLevels, loggerProfile: LoggerProfile) {
    if var logProfiles = loggers[logLevel] {
      if let index = logProfiles.index(where: { $0.loggerProfileId == loggerProfile.loggerProfileId }) {
        logProfiles.remove(at: index)
      }
      loggers[logLevel] = logProfiles
    }
  }
  
  static func removeLogProfileFromAllLevels(loggerProfile: LoggerProfile) {
    LogLevels.allValues.forEach { (level) in
      removeLogProfileFromLevel(logLevel: level, loggerProfile: loggerProfile)
    }
  }
  
  static func hasLoggerForLevel(logLevel: LogLevels) -> Bool {
    guard let _ = loggers[logLevel] else { return false }
    return true
  }
}
