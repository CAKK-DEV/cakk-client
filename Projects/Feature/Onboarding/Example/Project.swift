import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "ExampleOnboarding",
  infoPlist: [
    "UILaunchStoryboardName": "LaunchScreen"
  ],
  dependencies: [
    Project.FeatureOnboarding
  ]
)
