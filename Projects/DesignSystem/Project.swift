import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: "DesignSystem",
  infoPlist: [
    "UIAppFonts": [
      "Pretendard-Thin.otf",
      "Pretendard-SemiBold.otf",
      "Pretendard-Regular.otf",
      "Pretendard-Medium.otf",
      "Pretendard-Light.otf",
      "Pretendard-ExtraLight.otf",
      "Pretendard-ExtraBold.otf",
      "Pretendard-Bold.otf",
      "Pretendard-Black.otf"
    ]
  ],
  dependencies: [
    .external(name: "Lottie"),
    .external(name: "SnapKit")
  ],
  supportsResources: true
)
