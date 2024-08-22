import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureSearch",
  dependencies: [
    Project.CommonUtil,
    Project.DesignSystem,
    Project.Router,
    Project.DomainSearch,
    Project.PreviewSupportSearch,
    Project.DIContainer,
    Project.LocationService,
    Project.AdManager,
    Project.AnalyticsService,
    External.PopupView
  ]
)
