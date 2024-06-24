import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "ExampleBusiness",
  infoPlist: [
    "UILaunchStoryboardName": "LaunchScreen",
    "BASE_URL": "$(BASE_URL)",
    "NSPhotoLibraryUsageDescription": "사진첩에 접근하려면 권한이 필요합니다.",
    "PHPhotoLibraryPreventAutomaticLimitedAccessAlert": "YES"
  ],
  dependencies: [
    Project.FeatureBusiness,
    Project.DomainBusiness,
    Project.NetworkBusiness,

    Project.DomainSearch,
    Project.NetworkSearch,

    Project.Router,
    Project.DIContainer
  ]
)