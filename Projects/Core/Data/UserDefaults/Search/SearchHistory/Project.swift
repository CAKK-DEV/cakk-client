import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "UserDefaultsSearchHistory",
  dependencies: [
    Project.DomainSearch
  ]
)
