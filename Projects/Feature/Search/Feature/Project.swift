import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureSearch",
  dependencies: [
    Project.Shared,
    Project.DomainSearch,
    Project.PreviewSupportSearch,
    External.PopupView,
    External.LinkNavigator,
    External.SwiftUIPager
  ]
)
