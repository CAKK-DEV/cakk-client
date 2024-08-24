import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "CAKK-Admin",
  infoPlist: [
    "CFBundleShortVersionString": "1.0.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
    "BASE_URL": "$(BASE_URL)",
    "NSPhotoLibraryUsageDescription": "사진 선택을 위해 사진첩 접근 권한이 필요합니다.",
    "PHPhotoLibraryPreventAutomaticLimitedAccessAlert": "YES",
    "GIDClientID": "$(GIDClientID)",
        "CFBundleURLTypes": [
      [
        "CFBundleTypeRole": "Editor",
        "CFBundleURLSchemes": ["$(GOOGLE_URL_SCHEME)"]
      ],
      [
        "CFBundleTypeRole": "Editor",
        "CFBundleURLSchemes": ["$(KAKAO_URL_SCHEME)"]
      ]
    ],
  ],
  dependencies: [
    Project.FeatureUserAdmin,
    Project.NetworkBusinessOwner,
    Project.NetworkUser,

    Project.FeatureCakeShopAdmin,
    Project.NetworkCakeShop,
    Project.NetworkSearch,
    
    Project.KeyChainOAuthToken,
    Project.UserSession,
    Project.DIContainer,
    Project.MoyaUtil
  ],
  entitlements: "App.entitlements"
)
