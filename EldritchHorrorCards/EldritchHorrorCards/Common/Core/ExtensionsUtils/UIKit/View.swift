import UIKit

extension UIView {
	
	public func makeRound() {
		self.contentMode = .scaleAspectFill
		self.clipsToBounds = true
		var f = self.frame
		let w = f.width
		let h = f.height
		var corner = w
		if (h > w) { // Portrait Orientation
			f.size.height = w
		}
		else if (w > h) { // Landscape Orientation
			f.size.width = h
			corner = h
		}
		self.frame = f
		self.layer.cornerRadius = (corner / 2)
	}
	
	public func makeRoundWithBorder(width: CGFloat, color: UIColor) {
		makeRound()
		layer.borderWidth = width
		layer.borderColor = color.cgColor
	}
	
	public static func loadNib() -> Self {
		
		func loadNib<T: UIView>(_ viewType: T.Type) -> T {
			let bundle = Bundle(for: self)
			let nibName = self.description().components(separatedBy: ".").last!
			let nib = UINib(nibName: nibName, bundle: bundle)
			
			return nib.instantiate(withOwner: self, options: nil).first as! T
		}
		
		return loadNib(self)
	}
	
	public func embed(subview: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero, index: Int? = nil) {
		if let index = index {
			self.insertSubview(subview, at: index)
		}
		else {
			self.addSubview(subview)
		}
		
		subview.translatesAutoresizingMaskIntoConstraints = false
		
		let views = ["subview": subview]
		
		self.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "H:|-(\(insets.left))-[subview]-(\(insets.right))-|",
			options: [],
			metrics: nil,
			views: views))
		self.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: "V:|-(\(insets.top))-[subview]-(\(insets.bottom))-|",
			options: [],
			metrics: nil,
			views: views))
	}
	
	public func addConstraints(with format: String,
							   views: [String: Any],
							   options: NSLayoutFormatOptions = [],
							   metrics: [String: Any]? = nil) {
		self.addConstraints(NSLayoutConstraint.constraints(
			withVisualFormat: format,
			options: options,
			metrics: metrics,
			views: views))
	}
	
	@discardableResult
	public func addConstraint(with attr1: NSLayoutAttribute,
							  relatedBy relation: NSLayoutRelation = .equal,
							  toItem view2: Any? = nil,
							  attribute attr2: NSLayoutAttribute = .notAnAttribute,
							  multiplier: CGFloat = 1,
							  constant c: CGFloat = 0) -> NSLayoutConstraint {
		let constraint = NSLayoutConstraint(item: self,
											attribute: attr1,
											relatedBy: relation,
											toItem: view2,
											attribute: attr2,
											multiplier: multiplier,
											constant: c)
		self.addConstraint(constraint)
		
		return constraint
	}
}
