import ProjectDescription


// MARK: - Public

extension Project {
  
  private static let organizationName = "cakk"
  
  public static func app(name: String,
                         iOSTargetVersion: String = "16.4",
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
                   settings: .settings(configurations: [
                    .build(.prod, name: name),
                    .build(.stub, name: name),
                    .build(.release, name: name)
                   ]),
                   targets: targets,
                   schemes: [
                    .makeScheme(.prod, name: name),
                    .makeScheme(.stub, name: name),
                    .makeScheme(.release, name: name)
                   ]
    )
  }
  
  public static func framework(name: String,
                               iOSTargetVersion: String = "16.4",
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
                   settings: .settings(configurations: [
                    .build(.prod, name: name),
                    .build(.stub, name: name),
                    .build(.release, name: name)
                   ]),
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
    mergedInfoPlist["ITSAppUsesNonExemptEncryption"] = .string("NO")
    
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
        base: [
          "DEVELOPMENT_TEAM": "497P4L97SV",
          "OTHER_LDFLAGS": "$(inherited) -ObjC"
          ],
        configurations: [
          .build(.prod, name: name),
          .build(.stub, name: name),
          .build(.release, name: name)
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
        base: [
          "DEVELOPMENT_TEAM": "497P4L97SV",
          "OTHER_LDFLAGS": "$(inherited) -ObjC"
          ],
        configurations: [
          .build(.prod, name: name),
          .build(.release, name: name),
          .build(.stub, name: name)
        ],
        defaultSettings: .recommended)
      )
    )
    return [target]
  }
}
