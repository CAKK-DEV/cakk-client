import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureOnboarding",
  dependencies: [
    Project.CommonUtil,
    Project.DesignSystem,
    Project.Router,
    External.haptico
  ]
)
