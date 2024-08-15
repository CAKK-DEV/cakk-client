import Foundation
import GoogleMobileAds

public class InterstitialAdsManager: NSObject, GADFullScreenContentDelegate, ObservableObject {
  
  // MARK: - Properties
  
  @Published var interstitialAdLoaded: Bool = false
  
  private var interstitialAd: GADInterstitialAd?
  
  private var lastUsedAdUnit: AdUnit?
  public enum AdUnit {
    case mapDistanceAd
    case externalLinkAd
    
    var unitId: String {
      #if DEBUG
      return "ca-app-pub-3940256099942544/4411468910" // 테스트 전면광고 ID
      #else
      switch self {
      case .mapDistanceAd:
        return "ca-app-pub-3998172297943713/2033537593"
        
      case .externalLinkAd:
        return "ca-app-pub-3998172297943713/1925834189"
      }
      #endif
    }
  }
  
  
  // MARK: - Initializers
  
  /// `InterstitialAdsManager`의 새 인스턴스를 초기화합니다.
  public override init() {
    super.init()
  }
  
  
  // MARK: - Public Methods
  
  /// 전면 광고를 로드합니다.
  ///
  /// 이 메서드는 새 전면 광고를 요청하고 광고가 성공적으로 로드되면 `interstitialAdLoaded`
  /// 프로퍼티를 `true`로 설정합니다. 광고 로드에 실패하면 `interstitialAdLoaded` 프로퍼티를 `false`로 설정합니다.
  public func loadInterstitialAd(adUnit: AdUnit) {
    lastUsedAdUnit = adUnit
    
    GADInterstitialAd.load(withAdUnitID: adUnit.unitId, request: GADRequest()) { [weak self] ad, error in
      guard let self = self else { return }
      if let error = error {
        print("🔴: \(error.localizedDescription)")
        self.interstitialAdLoaded = false
        return
      }
      print("🟢: Loading succeeded")
      self.interstitialAdLoaded = true
      self.interstitialAd = ad
      self.interstitialAd?.fullScreenContentDelegate = self
    }
  }
  
  /// 전면 광고를 표시합니다.
  ///
  /// 이 메서드는 현재 루트 뷰 컨트롤러를 가져와서 전면 광고를 표시합니다.
  /// 만약 광고가 준비되지 않았다면, 광고를 다시 로드합니다.
  public func displayInterstitialAd(adUnit: AdUnit) {
    guard let root = UIApplication.shared.windows.first?.rootViewController else {
      return
    }
    if let ad = interstitialAd {
      ad.present(fromRootViewController: root)
      self.interstitialAdLoaded = false
    } else {
      print("🔵: Ad wasn't ready")
      self.interstitialAdLoaded = false
      self.loadInterstitialAd(adUnit: adUnit)
    }
  }
  
  // MARK: - GADFullScreenContentDelegate Methods
  
  /// 전면 광고 표시 실패 알림
  ///
  /// 전면 광고 표시가 실패하면 이 메서드가 호출되며, 새로운 광고를 로드합니다.
  public func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    print("🟡: Failed to display interstitial ad")
    if let lastUsedAdUnit {
      self.loadInterstitialAd(adUnit: lastUsedAdUnit)
    }
  }
  
  /// 전면 광고 표시 알림
  ///
  /// 전면 광고가 성공적으로 표시되면 이 메서드가 호출됩니다.
  public func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("🤩: Displayed an interstitial ad")
    self.interstitialAdLoaded = false
  }
  
  /// 전면 광고 닫힘 알림
  ///
  /// 전면 광고가 닫히면 이 메서드가 호출됩니다.
  public func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    print("😔: Interstitial ad closed")
  }
}
