import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureBusiness",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DesignSystem,
    
    Project.DomainSearch,
    Project.PreviewSupportSearch,

    Project.DomainUser,
    Project.PreviewSupportUser,

    Project.Router,
    Project.DIContainer,
    External.kingfisher
  ]
)
