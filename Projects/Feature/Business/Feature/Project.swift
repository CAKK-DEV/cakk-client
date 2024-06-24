import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureBusiness",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DesignSystem,

    Project.DomainBusiness,
    Project.PreviewSupportBusiness,
    
    Project.DomainSearch,
    Project.PreviewSupportSearch,

    Project.Router,
    Project.DIContainer,
    External.kingfisher
  ]
)
