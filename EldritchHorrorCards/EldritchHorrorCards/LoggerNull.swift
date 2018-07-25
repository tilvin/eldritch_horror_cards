struct LoggerNull: LoggerProfile {
  let loggerProfileId: String = "logger.null"
  func writeLog(level: String, message: String) { }
}
