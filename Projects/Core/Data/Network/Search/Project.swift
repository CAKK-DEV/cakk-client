import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkSearch",
  dependencies: [
    Project.Shared,
    Project.DomainSearch
  ],
  supportsResources: true
)
