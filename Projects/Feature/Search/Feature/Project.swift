import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureSearch",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DesignSystem,
    Project.Router,
    Project.DomainSearch,
    Project.PreviewSupportSearch,
    Project.DIContainer
  ]
)
