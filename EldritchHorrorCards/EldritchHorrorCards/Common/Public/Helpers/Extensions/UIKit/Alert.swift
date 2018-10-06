import UIKit

typealias Alert = UIAlertController

extension Alert {
	
	public convenience init(alert: String?, preferredStyle: UIAlertControllerStyle = .alert, actions: String ...) {
		self.init(title: nil,
				  message: alert,
				  preferredStyle: preferredStyle)
		
		actions.forEach { self.addAction(UIAlertAction(title: $0,
													   style: .default)) }
	}
	
	public convenience init(error: Error?) {
		let alert: String?
		alert = error?.localizedDescription
		self.init(alert: alert, actions: "Ok")
	}
	
	public func present(in controller: UIViewController?) {
		if let controller = controller {
			controller.present(self,
							   animated: true,
							   completion: nil)
		}
	}
	
	public func addAction(title: String?, style: UIAlertActionStyle = .default, handler: ((UIAlertAction) -> Void)? = nil) {
		self.addAction(UIAlertAction(title: title,
									 style: style,
									 handler: handler))
	}
}

extension Alert {
	
	public static func presentImagePicker<T: UIViewController>(in controller: T)
		where T: UIImagePickerControllerDelegate, T: UINavigationControllerDelegate {
			let alert = Alert(title: nil,
							  message: nil,
							  preferredStyle: .actionSheet)
			
			alert.addAction(title: NSLocalizedString("Camera", comment: "")) { _ in
				let c = UIImagePickerController()
				c.sourceType = .camera
				c.delegate = controller
				
				controller.present(c, animated: true)
			}
			
			alert.addAction(title: NSLocalizedString("Photo library", comment: "")) { _ in
				let c = UIImagePickerController()
				c.sourceType = .photoLibrary
				c.delegate = controller
				
				controller.present(c, animated: true)
			}
			
			alert.addAction(title: NSLocalizedString("Cancel", comment: ""),
							style: .cancel)
			
			alert.present(in: controller)
	}
}
