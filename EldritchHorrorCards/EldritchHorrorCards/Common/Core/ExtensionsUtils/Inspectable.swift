import UIKit

extension UIView {
  
  @IBInspectable public var borderWidth: CGFloat {
    set {
      self.layer.borderWidth = newValue
    }
    get {
      return self.layer.borderWidth
    }
  }
  
  @IBInspectable public var borderColor: UIColor? {
    set {
      self.layer.borderColor = newValue?.cgColor
    }
    get {
      return self.layer.borderColor != nil ? UIColor(cgColor: self.layer.borderColor!) : nil
    }
  }
  
  @IBInspectable public var cornerRadius: CGFloat {
    set {
      self.layer.cornerRadius = newValue
    }
    get {
      return self.layer.cornerRadius
    }
  }
  
  @IBInspectable public var masksToBounds: Bool {
    set {
      self.layer.masksToBounds = newValue
    }
    get {
      return self.layer.masksToBounds
    }
  }
  
  @IBInspectable public var shadowOffset: CGPoint {
    set {
      self.layer.shadowOffset = CGSize(width: newValue.x,
                                       height: newValue.y)
    }
    get {
      return CGPoint(x: self.layer.shadowOffset.width,
                     y: self.layer.shadowOffset.height)
    }
  }
  
  @IBInspectable public var shadowOpacity: CGFloat {
    set {
      self.layer.shadowOpacity = Float(newValue)
    }
    get {
      return CGFloat(self.layer.shadowOpacity)
    }
  }
  
  @IBInspectable public var shadowRadius: CGFloat {
    set {
      self.layer.shadowRadius = newValue
    }
    get {
      return self.layer.shadowRadius
    }
  }
  
  @IBInspectable public var shadowColor: UIColor? {
    set {
      self.layer.shadowColor = newValue?.cgColor
    }
    get {
      return self.layer.shadowColor != nil ? UIColor(cgColor: self.layer.shadowColor!) : nil
    }
  }
}

extension UITextField{
  
  @IBInspectable public var colorPH: UIColor? {
    get {
      return self.colorPH
    }
    set {
      self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
    }
  }
}

@IBDesignable public class DesignableView: UIView {
  
  @IBInspectable public var computeCornerRadius: Bool = false
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    
    if self.computeCornerRadius {
      self.cornerRadius = min(self.frame.width, self.frame.height) / 2
    }
  }
}
