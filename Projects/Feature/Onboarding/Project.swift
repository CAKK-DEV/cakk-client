import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureOnboarding",
  dependencies: [
    .project(target: "SwiftUIUtil", path: "../../Shared/Util/SwiftUIUtil"),
    .project(target: "DesignSystem", path: "../../DesignSystem"),
    .project(target: "Router", path: "../Router"),
    .external(name: "Haptico")
  ]
)
