import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportBusiness",
  dependencies: [
    Project.SwiftUIUtil,
    Project.DomainBusiness,
    Project.NetworkBusiness,
    Project.Router,
    Project.DIContainer
  ]
)
