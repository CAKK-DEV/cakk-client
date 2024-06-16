import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "ExampleSearch",
  infoPlist: [
    "UILaunchStoryboardName": "LaunchScreen",
    "BASE_URL": "$(BASE_URL)"
  ],
  dependencies: [
    Project.FeatureSearch,
    Project.NetworkSearch,
    Project.UserDefaultsSearchHistory
  ]
)
