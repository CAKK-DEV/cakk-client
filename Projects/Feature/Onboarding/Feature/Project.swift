import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureOnboarding",
  dependencies: [
    Project.CommonUtil,
    Project.DesignSystem,
    External.Haptico,
    External.LinkNavigator
  ]
)
