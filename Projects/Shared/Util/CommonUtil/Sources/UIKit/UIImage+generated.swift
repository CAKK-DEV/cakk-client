import UIKit

public extension UIImage {
  static func generated(fromEmoji emoji: String, fontSize: CGFloat) -> UIImage? {
    guard emoji.count == 1,
          emoji.containsEmoji() else {
      return nil
    }
    
    let attributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: fontSize)]
    let size = emoji.size(withAttributes: attributes)
    return UIGraphicsImageRenderer(size: size).image { _ in
      (emoji as NSString).draw(in: CGRect(origin: .zero, size: size),
                               withAttributes: attributes)
    }
  }
}

private extension String {
  func containsEmoji() -> Bool {
    for character in self {
      if character.isEmoji {
        return true
      }
    }
    
    return false
  }
}

private extension Character {
  var isEmoji: Bool {
    guard let scalar = unicodeScalars.first else { return false }
    return scalar.properties.isEmoji && (scalar.value > 0x238c || unicodeScalars.count > 1)
  }
}
