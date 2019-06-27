

import UIKit
import AVFoundation
import Photos

class ImagePickerManager: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate {

	// MARK:- Private properties
	private var postHandler: ((_ image: UIImage?, _ error: Error?) -> Void)?
	
	// MARK:- Private constants
	static let sourceUnavailable   = "Source Unavailable"
	static let permissionDenied    = "camera_permission"
	static let viewControllerError = "View Controller Not Found"
	static let pickCancelled       = "Image Pick Cancelled"
	static let imageNotFound       = "Image not found"
	
	/// Mark initializer private so that it cannot be accessed from other classes to make it a singleton.
	private override init() { }
	
	// MARK:- Public properties and methods
	/// Public singleton shared object of `ImagePickerManager`
	public static let shared = ImagePickerManager()
	
	/// Change this to hide errors for permission and source unavailability
	public let showAlerts = true
	
	/// Pick an Image from Camera.
	/// ```
	///	ImagePickerManager.shared.pickImageFromCamera(editing: true) {[weak self] (image, error) in
	///
	///		if let strongSelf = self {
	///			if image != nil {
	///				// Use image object
	///			} else {
	///				print(error?.localizedDescription)
	///			}
	///		}
	///	}
	/// ```
	/// - Parameters:
	///   - editing: Allow croping of picked image.
	///   - handler: Closure to Handle picked image. error will be nil if image picked successfully.
	///	  - image: Resulting image which is picked.
	///   - error: Error object if any error occured while picking image.
	public func pickImageFromCamera(editing: Bool, handler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
		pickImageFrom(source: .camera, editing: editing, handler: handler)
	}
	
	/// Pick an Image from Photo Library.
	/// ```
	///	ImagePickerManager.shared.pickImageFromPhotoLibrary(editing: true) {[weak self] (image, error) in
	///
	///		if let strongSelf = self {
	///			if image != nil {
	///				// Use image object
	///			} else {
	///				print(error?.localizedDescription)
	///			}
	///		}
	///	}
	/// ```
	/// - Parameters:
	///   - editing: Allow croping of picked image.
	///   - handler: Closure to Handle picked image. error will be nil if image picked successfully.
	///	  - image: Resulting image which is picked.
	///   - error: Error object if any error occured while picking image.
	public func pickImageFromPhotoLibrary(editing: Bool, handler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
		pickImageFrom(source: .photoLibrary, editing: editing, handler: handler)
	}
	
	/// Pick an Image from Photo Album.
	/// ```
	///	ImagePickerManager.shared.pickImageFromPhotoAlbum(editing: true) {[weak self] (image, error) in
	///
	///		if let strongSelf = self {
	///			if image != nil {
	///				// Use image object
	///			} else {
	///				print(error?.localizedDescription)
	///			}
	///		}
	///	}
	/// ```
	/// - Parameters:
	///   - editing: Allow croping of picked image.
	///   - handler: Closure to Handle picked image. error will be nil if image picked successfully.
	///	  - image: Resulting image which is picked.
	///   - error: Error object if any error occured while picking image.
	public func pickImageFromPhotoAlbum(editing: Bool, handler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
		pickImageFrom(source: .savedPhotosAlbum, editing: editing, handler: handler)
	}
	
	// MARK:- Private methods
    private func pickImageFrom(source: UIImagePickerController.SourceType, editing: Bool, handler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
		if !UIImagePickerController.isSourceTypeAvailable(source) {
			let error = ImagePickerError(description: ImagePickerManager.sourceUnavailable)
			showSourceErrorAlert()
			handler(nil, error)
		} else {
			
			do {
				try checkPermissions(source: source)
				
				let imagePicker = UIImagePickerController()
				imagePicker.sourceType = source
				imagePicker.allowsEditing = editing
				imagePicker.delegate = self
                imagePicker.navigationBar.tintColor = UIColor.white
                imagePicker.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.themePinkColor
                imagePicker.navigationBar.topItem?.rightBarButtonItem?.isEnabled = true
                imagePicker.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                if #available(iOS 11.0, *) {
                    imagePicker.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                } else {
                    // Fallback on earlier versions
                }
                
                // title text color white
                UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
                UINavigationBar.appearance().tintColor = UIColor.themePinkColor
                
                UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.themePinkColor], for: .normal)
                UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.themePinkColor], for: UIControl.State.highlighted)
				postHandler = handler
				
				if let viewController = Utile.getCurrentViewController() {
					viewController.present(imagePicker, animated: true, completion: nil)
					
					DispatchQueue.main.async {
						//viewController.view.alpha = 0.5
					}
					
				} else {
					let error = ImagePickerError(description: ImagePickerManager.viewControllerError)
					handler(nil, error)
				}
				
			} catch let error {
				showPermissionAlert()
				handler(nil, error)
			}
		}
	}
	
    private func checkPermissions(source: UIImagePickerController.SourceType) throws {
		if source == .camera {
            let cameraMediaType = AVMediaType.video
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
			
			switch cameraAuthorizationStatus {
			case .denied:
				throw ImagePickerError(description: ImagePickerManager.permissionDenied)
			default: break
			}
		} else {
			let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
			
			switch photoAuthorizationStatus {
			case .denied:
				throw ImagePickerError(description: ImagePickerManager.permissionDenied)
			default: break
			}
		}
	}
	
	private func showPermissionAlert() {
		
		if !showAlerts {
			return
		}
		
		let alert = UIAlertController(title: "", message: Alerts.KPERMISIONDENIED, preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: "Alerts.kAlertCancel", style: .cancel, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		})
		
		let settingAction = UIAlertAction(title: Alerts.KSETTING, style: .default, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:])
			}
		})
		
        alert.view.tintColor = UIColor.themePinkColor
		alert.addAction(cancelAction)
		alert.addAction(settingAction)
		alert.preferredAction = settingAction
		
		if let viewController = Utile.getCurrentViewController() {
			viewController.present(alert, animated: true, completion: nil)
		}
		
	}
	
	private func showSourceErrorAlert() {
		if !showAlerts {
			return
		}
		
		let alert = UIAlertController(title: "", message: ImagePickerManager.sourceUnavailable, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: Alerts.kAlertOK, style: .default, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		}))
		
		if let viewController = Utile.getCurrentViewController() {
			viewController.present(alert, animated: true, completion: nil)
		}
	}
	

	
	// MARK:- UIImagePickerControllerDelegate implementation
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		
		let error = ImagePickerError(description: ImagePickerManager.pickCancelled)
		if let handler = postHandler {
			handler(nil, error)
		}
		
		picker.dismiss(animated: true) {
			if let viewController = Utile.getCurrentViewController() {
				viewController.view.alpha = 1.0
                UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
                UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: UIControl.State.highlighted)
                UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
			}
		}
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
			if let handler = postHandler {
				handler(editedImage, nil)
			}
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			if let handler = postHandler {
				handler(originalImage, nil)
			}
		} else {
			let error = ImagePickerError(description: ImagePickerManager.imageNotFound)
			if let handler = postHandler {
				handler(nil, error)
			}
		}
		
		picker.dismiss(animated: true) {
			if let viewController = Utile.getCurrentViewController() {
				viewController.view.alpha = 1.0
			}
		}
	}
	
	// MARK:- UIPopoverPresentationControllerDelegate implementation
	func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
		let error = ImagePickerError(description: ImagePickerManager.pickCancelled)
		if let handler = postHandler {
			handler(nil, error)
		}
		
		if let viewController = Utile.getCurrentViewController() {
			viewController.view.alpha = 1.0
		}
	}
}

// MARK:- Error handling for ImagePickerManager
class ImagePickerError: NSObject, LocalizedError {
	
	private var desc = ""
	
	init(description: String) {
		desc = description
	}
	
	override var description: String {
		get {
			return "ImagePickerManager: \(desc)"
		}
	}
	
	var errorDescription: String? {
		get {
			return self.description
		}
	}
}
