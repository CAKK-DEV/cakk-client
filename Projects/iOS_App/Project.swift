import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "CAKK",
  infoPlist: [
    "CFBundleShortVersionString": "2.0.2",
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
    "PHPhotoLibraryPreventAutomaticLimitedAccessAlert": "YES",
    "NSLocationWhenInUseUsageDescription": "보다 정확한 검색 결과를 위해서 위치 권한이 필요합니다.",
    "NSUserTrackingUsageDescription": "맞춤형 광고와 향상된 서비스를 제공하기 위해 광고 식별자를 사용하고자 합니다",
    "GADApplicationIdentifier": "$(GAD_APPLICATION_ID)"
  ],
  dependencies: [
    Project.FeatureUser,
    Project.NetworkUser,

    Project.FeatureSearch,
    Project.NetworkSearch,
    Project.UserDefaultsSearchHistory,

    Project.FeatureCakeShop,
    Project.NetworkCakeShop,

    Project.DomainBusinessOwner,
    Project.NetworkBusinessOwner,

    Project.FeatureCakeShopAdmin,

    Project.FeatureOnboarding,
    Project.KeyChainOAuthToken,
    Project.UserSession,
    Project.DIContainer,

    Project.NetworkImage,

    Project.AdManager,

    External.FirebaseAnalytics
  ],
  entitlements: "App.entitlements"
)
