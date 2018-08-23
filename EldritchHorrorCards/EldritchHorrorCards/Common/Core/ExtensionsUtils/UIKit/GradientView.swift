import UIKit

enum GradientDirection {
  case horizontal, vertical
}

struct GradientColor {
  let left: UIColor
  let right: UIColor
}

@IBDesignable class GradientView: UIView {
  
  fileprivate var gradientLayer: CAGradientLayer {
    return self.layer as! CAGradientLayer
  }
  
  @IBOutlet var gradientMask: UIView? {
    didSet {
      self.gradientLayer.mask = gradientMask?.layer
    }
  }
  
  var colors: [UIColor] = [] {
    didSet {
      self.gradientLayer.colors = colors.map { $0.cgColor }
      self.gradientLayer.setNeedsDisplay()
    }
  }
  
  var locations: [CGFloat] = [] {
    didSet {
      self.gradientLayer.locations = self.locations as [NSNumber]
      self.gradientLayer.setNeedsDisplay()
    }
  }
  
  @IBInspectable var startColor: UIColor? {
    set {
      if let color = newValue {
        self.colors.insert(color, at: 0)
      }
    }
    get {
      return self.colors.first
    }
  }
  
  @IBInspectable var endColor: UIColor? {
    set {
      if let color = newValue {
        self.colors.append(color)
      }
    }
    get {
      return self.colors.last
    }
  }
  
  @IBInspectable var startPoint: CGPoint = CGPoint.zero {
    didSet {
      self.gradientLayer.startPoint = startPoint
    }
  }
  
  @IBInspectable var endPoint: CGPoint = CGPoint.zero {
    didSet {
      self.gradientLayer.endPoint = endPoint
    }
  }
  
  // MARK: Init
  
  deinit {
    self.gradientLayer.mask = nil
    self.gradientMask?.removeFromSuperview()
    self.gradientMask = nil
  }
  
  // MARK: Lifecycle
  
  override static var layerClass : AnyClass {
    return CAGradientLayer.self
  }
  
  func setupGradientColor(gradientColor: GradientColor, direction: GradientDirection? = nil) {
    self.startColor = gradientColor.left
    self.endColor = gradientColor.right
    self.startPoint = CGPoint(x: direction == .vertical ? 0.5 : 0,
                              y: direction == .vertical ? 0 : 0.5)
    self.endPoint = CGPoint(x: direction == .vertical ? 0.5 : 1,
                            y: direction == .vertical ? 1 : 0.5)
  }
}

