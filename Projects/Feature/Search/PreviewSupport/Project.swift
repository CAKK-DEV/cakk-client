import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportSearch",
  dependencies: [
    Project.Shared,
    Project.DomainSearch
  ]
)
