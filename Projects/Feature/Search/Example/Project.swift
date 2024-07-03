import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "ExampleSearch",
  infoPlist: [
    "UILaunchStoryboardName": "LaunchScreen",
    "BASE_URL": "$(BASE_URL)",
    "NSLocationWhenInUseUsageDescription": "보다 정확한 검색 결과를 위해서 위치 권한이 필요합니다."
  ],
  dependencies: [
    Project.FeatureSearch,
    Project.NetworkSearch,
    Project.UserDefaultsSearchHistory,
    External.kingfisher
  ]
)
