import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "ExampleCakeShop",
  infoPlist: [
    "UILaunchStoryboardName": "LaunchScreen",
    "BASE_URL": "$(BASE_URL)"
  ],
  dependencies: [
    .project(target: "FeatureCakeShop", path: "../CakeShop")
  ]
)