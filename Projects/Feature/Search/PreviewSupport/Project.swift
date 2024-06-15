import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportSearch",
  dependencies: [
    Project.DomainSearch,
    Project.DIContainer
  ]
)
