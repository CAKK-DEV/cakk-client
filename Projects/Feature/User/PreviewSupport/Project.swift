import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportUser",
  dependencies: [
    Project.DomainUser,
    .external(name: "Swinject")
  ]
)
