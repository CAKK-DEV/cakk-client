import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "ExampleOnboarding",
  infoPlist: [
    "UILaunchStoryboardName": "LaunchScreen"
  ],
  dependencies: [
    .project(target: "FeatureOnboarding", path: "../Onboarding")
  ]
)