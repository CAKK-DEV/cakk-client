import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "FeatureCakeShop",
  dependencies: [
    Project.CommonUtil,
    Project.DesignSystem,
    Project.Router,
    Project.DomainCakeShop,
    Project.PreviewSupportCakeShop,
    Project.DomainSearch,
    Project.PreviewSupportSearch,
    Project.DomainUser,
    Project.PreviewSupportUser,
    Project.LocationService,
    Project.DIContainer,
    Project.Logger,
    Project.AdManager,
    Project.AnalyticsService,
    External.Kingfisher,
    External.ExpandableText,
    External.FirebaseFirestore
  ]
)
