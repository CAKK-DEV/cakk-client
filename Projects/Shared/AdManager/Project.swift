import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "AdManager",
  dependencies: [
    External.GoogleMobileAds
  ]
)
