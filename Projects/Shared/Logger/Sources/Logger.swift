import OSLog

public struct Logger {
  
  // MARK: - Properties
  
  private let subsystem: String
  private let logger: os.Logger
  
  public enum LogCategory: String {
    case ui
    case network
    case auth
  }
  
  
  // MARK: - Initializers
  
  public init(subsystem: String = Bundle.main.bundleIdentifier!) {
    self.subsystem = subsystem
    self.logger = os.Logger(subsystem: subsystem, category: "")
  }
  
  
  // MARK: - Public Methods
  
  public func log(_ message: String, category: LogCategory, type: OSLogType = .default) {
    let dynamicLogger = os.Logger(subsystem: subsystem, category: category.rawValue)
    dynamicLogger.log(level: type, "\(message, privacy: .public)")
  }
  
  public func info(_ message: String, category: LogCategory) {
    log(message, category: category, type: .info)
  }
  
  public func debug(_ message: String, category: LogCategory) {
    log(message, category: category, type: .debug)
  }
  
  public func error(_ message: String, category: LogCategory) {
    log(message, category: category, type: .error)
  }
  
  public func fault(_ message: String, category: LogCategory) {
    log(message, category: category, type: .fault)
  }
}

public struct Loggers {
  public static let featureCakeShop = Logger(subsystem: "com.cakk.FeatureCakeShop")
  public static let networkCakeShop = Logger(subsystem: "com.cakk.NetworkCakeShop")
  
  public static let networkBusinessOwner = Logger(subsystem: "com.cakk.NetworkBusinessOwner")
  public static let networkImage = Logger(subsystem: "com.cakk.NetworkImage")
  public static let networkSearch = Logger(subsystem: "com.cakk.NetworkSearch")
  
  public static let networkUser = Logger(subsystem: "com.cakk.NetworkUser")
  public static let featureUser = Logger(subsystem: "com.cakk.FeatureUser")
  
  public static let designSystem = Logger(subsystem: "com.cakk.DesignSystem")
}
