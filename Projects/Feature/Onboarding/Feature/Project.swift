import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureOnboarding",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DesignSystem,
    Project.Router,
    .external(name: "Haptico")
  ]
)
