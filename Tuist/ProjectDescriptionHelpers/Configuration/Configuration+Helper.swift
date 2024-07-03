import ProjectDescription

public enum BuildTarget: String {
  case stub = "STUB"
  case prod = "PROD"
  case release = "RELEASE"
  
  public var configurationName: ConfigurationName {
    return ConfigurationName.configuration(self.rawValue)
  }
}

extension Configuration {
  public static func build(_ type: BuildTarget, name: String = "") -> Self {
    switch type {
    case .stub, .prod:
      return .debug(name: type.configurationName,
                    xcconfig: .relativeToRoot("XCConfig/Secrets.xcconfig"))
    case .release:
      return .release(name: .release,
                      xcconfig: .relativeToRoot("XCConfig/Secrets.xcconfig"))
    }
  }
}
