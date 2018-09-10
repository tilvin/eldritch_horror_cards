import UIKit

extension UIViewController {
	
	public func setupSpinner(isLarge: Bool = false) {
		let spinner = UIActivityIndicatorView(activityIndicatorStyle: isLarge ? .whiteLarge : .gray)
		spinner.color = .viridianTwo
		spinner.hidesWhenStopped = true
		spinner.startAnimating()
		spinner.tag = 100
		self.view.addSubview(spinner)
	}
	
	public func setupBlurAppear(blurDuration: Double, blurViewPosition: Int = -1, completion: (() -> Void)? = nil) {
		DispatchQueue.main.asyncAfter(deadline: .now() + blurDuration) {
			let tag = self.setupBlur(blurViewPosition: blurViewPosition)
			self.view.subviews
				.filter { return $0.tag == tag }
				.forEach { (view) in  UIView.animate(withDuration: 1, animations: {
					view.alpha  = 0
				}, completion: { (_) in
					view.removeFromSuperview()
					if let completion = completion {
						completion()
					}
				})
			}
		}
	}
	
	public func setupBlur(blurViewPosition: Int = -1, tag: Int = 999) -> Int {
		let blurEffect = UIBlurEffect(style: .light)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		blurEffectView.frame = self.view.bounds
		blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		blurEffectView.tag = tag
		self.view.insertSubview(blurEffectView, at: blurViewPosition < 0 ? self.view.subviews.count - 1 : blurViewPosition)
		
		return blurEffectView.tag
	}
	
	public func setStatusbar(with color: UIColor) {
		let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
		if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
			statusBar.backgroundColor = color
			statusBar.tintColor = .white
		}
	}
}
