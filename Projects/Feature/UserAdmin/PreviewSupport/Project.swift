import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportUserAdmin",
  dependencies: [
    Project.DomainUser,
    Project.DomainBusinessOwner
  ]
)
