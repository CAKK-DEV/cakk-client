import ProjectDescription

public enum External {
  public static var Swinject: TargetDependency {
    return .external(name: "Swinject")
  }
  
  public static var Lottie: TargetDependency {
    return .external(name: "Lottie")
  }
  
  public static var SnapKit: TargetDependency {
    return .external(name: "SnapKit")
  }
  
  public static var Haptico: TargetDependency {
    return .external(name: "Haptico")
  }
  
  public static var Moya: TargetDependency {
    return .external(name: "Moya")
  }
  
  public static var CombineMoya: TargetDependency {
    return .external(name: "CombineMoya")
  }
  
  public static var KakaoSDKCommon: TargetDependency {
    return .external(name: "KakaoSDKCommon")
  }
  
  public static var KakaoSDKAuth: TargetDependency {
    return .external(name: "KakaoSDKAuth")
  }
  
  public static var KakaoSDKUser: TargetDependency {
    return .external(name: "KakaoSDKUser")
  }

  public static var Kingfisher: TargetDependency {
    return .external(name: "Kingfisher")
  }

  public static var ExpandableText: TargetDependency {
    return .external(name: "ExpandableText")
  }
}
