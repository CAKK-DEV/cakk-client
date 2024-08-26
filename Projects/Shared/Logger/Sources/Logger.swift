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
  
  /**
   지정된 카테고리와 로그 레벨로 메시지를 기록합니다.

   - Parameters:
      - message: 로그로 남길 메시지.
      - category: 로그의 카테고리로, .ui, network, .auth 와 관련된 로그를 구분하기 위해 사용됩니다.
      - type: 로그의 레벨 또는 유형 (`.default`가 기본값). 로그의 심각도를 결정합니다.

   - Discussion:
      이 함수는 `os.Logger`를 사용하여 로그를 기록하며, 주어진 메시지와 카테고리에 따라 로그가 생성됩니다. 카테고리는 UI, 네트워크(Network), 인증(Auth)와 같은 범주로 설정될 수 있습니다. 로그 레벨에 따라 기본 로그, 정보 로그, 디버그 로그, 오류 로그, 중대한 오류 로그로 나뉩니다.
   */
  public func log(_ message: String, category: LogCategory, type: OSLogType = .default) {
      let dynamicLogger = os.Logger(subsystem: subsystem, category: category.rawValue)
      dynamicLogger.log(level: type, "\(message, privacy: .public)")
  }

  /**
   정보 로그를 기록합니다.

   - Parameters:
      - message: 로그로 남길 메시지.
      - category: 로그의 카테고리로, .ui, network, .auth 와 관련된 로그를 구분하기 위해 사용됩니다.

   - Discussion:
      이 함수는 주로 애플리케이션의 일반적인 상태나 흐름을 기록하는 데 사용됩니다. 예를 들어, 네트워크 요청의 성공 또는 UI 상태 변경과 같은 정보 로그를 기록할 때 사용됩니다.
   */
  public func info(_ message: String, category: LogCategory) {
      log(message, category: category, type: .info)
  }

  /**
   디버그 로그를 기록합니다.

   - Parameters:
      - message: 로그로 남길 메시지.
      - category: 로그의 카테고리로, .ui, network, .auth 와 관련된 로그를 구분하기 위해 사용됩니다.

   - Discussion:
      이 함수는 개발 중 발생하는 문제를 해결하거나 디버깅할 때 유용합니다. 코드의 흐름, 변수 값, 네트워크 응답 등을 확인하기 위해 디버그 로그를 기록할 수 있습니다.
   */
  public func debug(_ message: String, category: LogCategory) {
      log(message, category: category, type: .debug)
  }

  /**
   오류 로그를 기록합니다.

   - Parameters:
      - message: 로그로 남길 메시지.
      - category: 로그의 카테고리로, .ui, network, .auth 와 관련된 로그를 구분하기 위해 사용됩니다.

   - Discussion:
      이 함수는 애플리케이션에서 예외 상황이나 처리할 수 있는 오류가 발생했을 때 사용됩니다. 예를 들어, 네트워크 요청 실패나 인증 오류를 기록할 때 적합합니다.
   */
  public func error(_ message: String, category: LogCategory) {
      log(message, category: category, type: .error)
  }

  /**
   중대한 오류 로그를 기록합니다.

   - Parameters:
      - message: 로그로 남길 메시지.
      - category: 로그의 카테고리로, .ui, network, .auth 와 관련된 로그를 구분하기 위해 사용됩니다.

   - Discussion:
      이 함수는 시스템의 정상적인 운영에 심각한 영향을 미칠 수 있는 치명적인 오류가 발생했을 때 사용됩니다. 주로 복구가 불가능하거나 매우 위험한 상황을 기록합니다.
   */
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
