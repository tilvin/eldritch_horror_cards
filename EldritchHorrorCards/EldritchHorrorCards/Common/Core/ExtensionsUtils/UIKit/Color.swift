import UIKit

extension UIColor {
  
  public convenience init(hexString: String) {
    let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int = UInt32()
    Scanner(string: hex).scanHexInt32(&int)
    let a, r, g, b: UInt32
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // RGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 1)
    }
    self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
  }
  
  public func image(with size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
    let rect: CGRect = CGRect(origin: CGPoint(), size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    self.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image
  }
}

// MARK: - Darker/Lighter

extension UIColor {
  
  public func darker() -> UIColor {
    
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    
    if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
      return UIColor(red: max(r - 0.13, 0.0), green: max(g - 0.13, 0.0), blue: max(b - 0.13, 0.0), alpha: a)
    }
    
    return UIColor()
  }
  
  public func lighter() -> UIColor {
    
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    
    if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
      return UIColor(red: min(r + 0.13, 1.0), green: min(g + 0.13, 1.0), blue: min(b + 0.13, 1.0), alpha: a)
    }
    
    return UIColor()
  }
  
  public func isNear(to color: UIColor) -> Bool {
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    var rc: CGFloat = 0, gc: CGFloat = 0, bc: CGFloat = 0, ac: CGFloat = 0
    self.getRed(&r, green: &g, blue: &b, alpha: &a)
    color.getRed(&rc, green: &gc, blue: &bc, alpha: &ac)
    
    let s = r * 255.0 + g * 255.0 + b * 255.0
    let c = rc * 255.0 + gc * 255.0 + bc * 255.0
    
    return abs(c - s) <= 255
  }
}
