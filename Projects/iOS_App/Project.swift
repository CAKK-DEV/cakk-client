import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "CAKK",
  infoPlist: [
    "CFBundleShortVersionString": "2.0.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
    "BASE_URL": "$(BASE_URL)",
    "GIDClientID": "$(GIDClientID)",
    "KAKAO_SDK_APP_KEY": "$(KAKAO_SDK_APP_KEY)",
    "LSApplicationQueriesSchemes": [
      "kakaokompassauth",
      "kakaolink"
    ],
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
    "NSPhotoLibraryUsageDescription": "프로필 사진 선택을 위해 사진첩 접근 권한이 필요합니다.",
    "PHPhotoLibraryPreventAutomaticLimitedAccessAlert": "YES"
  ],
  dependencies: [
    Project.FeatureUser,
    Project.NetworkUser,

    Project.FeatureSearch,
    Project.NetworkSearch,
    Project.UserDefaultsSearchHistory,

    Project.FeatureCakeShop,
    Project.NetworkCakeShop,

    Project.FeatureOnboarding,
    Project.KeyChainOAuthToken,
    Project.UserSession,
    Project.DIContainer
  ],
  entitlements: "App.entitlements"
)
