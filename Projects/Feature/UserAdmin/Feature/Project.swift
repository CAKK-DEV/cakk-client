import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureUserAdmin",
  dependencies: [
    Project.CommonUtil,
    Project.DesignSystem,
    Project.Router,
    Project.LocationService,
    
    Project.DomainUser,
    Project.DomainBusinessOwner,
    
    Project.PreviewSupportUser,
    Project.PreviewSupportSearch,

    Project.CommonUtil,
    Project.UserSession,
    .package(product: "GoogleSignIn")
  ],
  packages: [
    .remote(url: "https://github.com/google/GoogleSignIn-iOS", requirement: .upToNextMajor(from: "7.1.0"))
  ]
)
