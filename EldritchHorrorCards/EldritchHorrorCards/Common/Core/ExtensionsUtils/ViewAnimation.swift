import UIKit

extension UIView {
  
  public func shake() {
    let shake = CABasicAnimation(keyPath: "position")
    shake.duration = 0.1
    shake.repeatCount = 2
    shake.autoreverses = true
    shake.fromValue = [self.center.x - 5, self.center.y]
    shake.toValue = [self.center.x + 5, self.center.y]
    self.layer.add(shake, forKey: "position")
  }
  
  public func rotate(to radians: Double, duration: TimeInterval = -1) {
    let animation: () -> () = {
      self.transform = CGAffineTransform(rotationAngle: CGFloat(radians))
    }
    
    if duration > 0 {
      UIView.animate(withDuration: duration, animations: animation)
    }
    else {
      animation()
    }
  }
  
  private static let kRotationAnimationKey = "rotationanimationkey"
  
  public func rotate(duration: Double = 1) {
    if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
      let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
      
      rotationAnimation.fromValue = 0.0
      rotationAnimation.toValue = Float.pi * 2.0
      rotationAnimation.duration = duration
      rotationAnimation.repeatCount = Float.infinity
      
      layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
    }
  }
  
  public func stopRotating() {
    if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
      layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
    }
  }
}
