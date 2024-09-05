import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureOnboarding",
  dependencies: [
    Project.Shared,
    External.Haptico,
    External.LinkNavigator
  ]
)
