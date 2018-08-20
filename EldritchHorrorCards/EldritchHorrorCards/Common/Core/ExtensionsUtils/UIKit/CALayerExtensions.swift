import UIKit

extension CALayer {
	
	public func addShadow(with offset: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat = 0.0, color: UIColor = UIColor.black) {
		shadowOffset = offset
		shadowOpacity = opacity
		self.shadowRadius = shadowRadius
		shadowColor = color.cgColor
		masksToBounds = false
		self.cornerRadius = cornerRadius
		
		if shadowRadius != 0.0 { addShadowWithRoundedCorners() }
	}
	
	private func roundCorners(radius: CGFloat) {
		cornerRadius = radius
		if shadowOpacity != 0.0 { addShadowWithRoundedCorners() }
	}
	
	private func addShadowWithRoundedCorners() {
		if let contents = self.contents {
			masksToBounds = false
			sublayers?.filter { $0.frame.equalTo(self.bounds) }
				.forEach { $0.roundCorners(radius: self.cornerRadius) }
			self.contents = nil
			if let sublayer = sublayers?.first,
				sublayer.name == "contentLayer" {
				sublayer.removeFromSuperlayer()
			}
			let contentLayer = CALayer()
			contentLayer.name = "contentLayer"
			contentLayer.contents = contents
			contentLayer.frame = bounds
			contentLayer.cornerRadius = cornerRadius
			contentLayer.masksToBounds = true
			insertSublayer(contentLayer, at: 0)
		}
	}
}
