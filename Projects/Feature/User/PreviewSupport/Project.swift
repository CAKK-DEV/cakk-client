import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportUser",
  dependencies: [
    Project.Shared,
    Project.DomainUser,
    Project.DomainBusinessOwner,
  ]
)
