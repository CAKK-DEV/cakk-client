import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "NetworkSearch",
  dependencies: [
    Project.DomainSearch,
    Project.Logger
  ],
  supportsResources: true
)
