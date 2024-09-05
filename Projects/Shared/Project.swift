import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "Shared",
  dependencies: [
    Project.DesignSystem,
    Project.AdManager,
    Project.AnalyticsService,
    Project.Logger,
    Project.LocationService,
    Project.CommonUtil,
    Project.TokenUtil,
    Project.DIContainer
  ],
  supportsSources: false
)
