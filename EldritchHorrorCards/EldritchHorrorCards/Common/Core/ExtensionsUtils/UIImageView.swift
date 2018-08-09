import UIKit

private class DownloadQueue {
	
	fileprivate var queue = [String: Download]()
	
	fileprivate class var _sharedQeueue: DownloadQueue {
		struct Static {
			static let instance = DownloadQueue()
		}
		return Static.instance
	}
	
	class func sharedQeueue() -> DownloadQueue {
		return _sharedQeueue
	}
	
	func enqueue(_ download: Download, forImageURL imageURL: String) {
		queue[imageURL] = download
	}
	
	func removeDownloadForImageURL(_ imageURL: String) {
		if let _imageURL = imageURL as String? {
			queue.removeValue(forKey: _imageURL)
		}
	}
	
	func downloadForImageURL(_ imageURL: String) -> Download? {
		return queue[imageURL]
	}
}

private struct Download {
	var task: URLSessionDataTask?
}

public extension UIImageView {
	
	public func set(image: UIImage,duration: CGFloat = 1.5, animation: Bool = true) {
		let imageView = UIImageView(frame: self.frame)
		imageView.image = image
		imageView.alpha = 0
		if animation {
			self.addSubview(imageView)
			UIView.animate(withDuration: TimeInterval(duration), animations: {
				imageView.alpha = 1.0
			})
			{ (_) in
				self.image = image
				imageView.removeFromSuperview()
			}
		}
		else {
			imageView.alpha = 1
			self.addSubview(imageView)
		}
	}
	
	public func loadImageAtURL(_ imageURL: String, withDefaultImage defaultImage: UIImage?) {
		loadImageAtURL(imageURL, withDefaultImage: defaultImage, completion: nil)
	}
	
	public func loadImageAtURL(_ imageURL: String, withDefaultImage defaultImage: UIImage?, completion: (() -> Void)?) {
		if let _defaultImage = defaultImage { image = _defaultImage }
		
		let request = URLRequest(url: URL(string: imageURL)!)
		let downloadTask = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			if let _data = data {
				DispatchQueue.main.async {
					self.image = nil
					self.image = UIImage(data: _data)
					completion?()
				}
			}
			DownloadQueue.sharedQeueue().removeDownloadForImageURL(imageURL + "\(self.hash)")
		})
		DownloadQueue.sharedQeueue().enqueue(Download(task: downloadTask), forImageURL: imageURL + "\(hash)")
		downloadTask.resume()
	}
	
	public func cancelImageLoadForImageURL(_ imageURL: String) {
		if let _download = DownloadQueue.sharedQeueue().downloadForImageURL(imageURL + "\(hash)") {
			_download.task?.cancel()
		}
		DownloadQueue.sharedQeueue().removeDownloadForImageURL(imageURL + "\(hash)")
	}
}
