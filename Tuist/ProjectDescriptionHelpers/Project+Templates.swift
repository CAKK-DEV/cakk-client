import ProjectDescription


// MARK: - Public

extension Project {
  
  private static let organizationName = "cakk"
  
  public static func app(name: String,
                         iOSTargetVersion: String = "16.0",
                         infoPlist: [String : Plist.Value] = [:],
                         dependencies: [TargetDependency] = [],
                         packages: [Package] = [],
                         extraTargets: [Target] = [],
                         entitlements: Entitlements? = nil) -> Project {
    var targets = makeAppTargets(name: name,
                                 iOSTargetVersion: iOSTargetVersion,
                                 infoPlist: infoPlist,
                                 dependencies: dependencies,
                                 entitlements: entitlements)
    targets.append(contentsOf: extraTargets)
    return Project(name: name,
                   organizationName: organizationName,
                   packages: packages,
                   targets: targets)
  }
  
  public static func framework(name: String,
                               iOSTargetVersion: String = "16.0",
                               infoPlist: [String : Plist.Value] = [:],
                               dependencies: [TargetDependency] = [],
                               supportsResources: Bool = false,
                               packages: [Package] = [],
                               extraTargets: [Target] = []) -> Project {
    var targets = makeFrameworkTargets(name: name,
                                       iOSTargetVersion: iOSTargetVersion,
                                       infoPlist: infoPlist,
                                       dependencies: dependencies,
                                       supportsResources: supportsResources)
    targets.append(contentsOf: extraTargets)
    return Project(name: name,
                   organizationName: organizationName,
                   packages: packages,
                   targets: targets)
  }
}

// MARK: - Private

extension Project {
  public static func makeAppTargets(name: String,
                                    iOSTargetVersion: String,
                                    infoPlist: [String : Plist.Value],
                                    dependencies: [TargetDependency] = [],
                                    entitlements: Entitlements? = nil) -> [Target] {
    // Default InfoPlist
    var mergedInfoPlist = infoPlist
    let supportedOrientations: [String] = [
      "UIInterfaceOrientationPortrait"
    ]
    mergedInfoPlist["UISupportedInterfaceOrientations"] = .array(supportedOrientations.map { .string($0) })
    mergedInfoPlist["UIUserInterfaceStyle"] = .string("Light")
    
    let target = Target.target(
      name: name,
      destinations: [.iPad, .iPhone],
      product: .app,
      bundleId: "com.prography.\(name)",
      deploymentTargets: .iOS(iOSTargetVersion),
      infoPlist: .extendingDefault(with: mergedInfoPlist),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      entitlements: entitlements,
      dependencies: dependencies,
      settings: .init(.settings(
        base: ["DEVELOPMENT_TEAM": "YOUR_TEM_ID"],
        configurations: [
          .debug(name: "Debug", xcconfig: .relativeToRoot("XCConfig/Secrets.xcconfig")),
          .release(name: "Release", xcconfig: .relativeToRoot("XCConfig/Secrets.xcconfig"))
        ],
        defaultSettings: .recommended)
      )
    )
    return [target]
  }
  
  private static func makeFrameworkTargets(name: String,
                                           iOSTargetVersion: String,
                                           infoPlist: [String : Plist.Value],
                                           dependencies: [TargetDependency] = [],
                                           supportsResources: Bool = false) -> [Target] {
    let target = Target.target(
      name: name,
      destinations: [.iPad, .iPhone],
      product: .framework,
      bundleId: "com.prography.\(name)",
      deploymentTargets: .iOS(iOSTargetVersion),
      infoPlist: .extendingDefault(with: infoPlist),
      sources: ["Sources/**"],
      resources: supportsResources ? ["Resources/**"] : [],
      dependencies: dependencies,
      settings: .init(.settings(
        base: ["DEVELOPMENT_TEAM": "YOUR_TEAM_ID"],
        configurations: [
          .debug(name: "Debug", xcconfig: .relativeToRoot("XCConfig/Secrets.xcconfig")),
          .release(name: "Release", xcconfig: .relativeToRoot("XCConfig/Secrets.xcconfig"))
        ],
        defaultSettings: .recommended)
      )
    )
    return [target]
  }
}
