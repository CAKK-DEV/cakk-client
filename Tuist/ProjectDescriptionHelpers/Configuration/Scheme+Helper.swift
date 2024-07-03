import ProjectDescription

extension Scheme {
  public static func makeScheme(_ type: BuildTarget, name: String) -> Self {
    switch type {
    case .stub, .prod:
      scheme(
        name: "\(name)-\(type.rawValue.uppercased())",
        buildAction: .buildAction(targets: ["\(name)"]),
        runAction: .runAction(configuration: type.configurationName),
        archiveAction: .archiveAction(configuration: type.configurationName),
        profileAction: .profileAction(configuration: type.configurationName),
        analyzeAction: .analyzeAction(configuration: type.configurationName)
      )
    case .release:
      scheme(
        name: "\(name)-\(type.rawValue.uppercased())",
        buildAction: .buildAction(targets: ["\(name)"]),
        runAction: .runAction(configuration: .release),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: type.configurationName)
      )
    }
  }
}
