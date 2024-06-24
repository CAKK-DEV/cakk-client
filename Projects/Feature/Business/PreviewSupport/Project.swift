import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "PreviewSupportBusiness",
  dependencies: [
    Project.SwiftUIUtil,
    Project.Router,
    Project.DIContainer
  ]
)
