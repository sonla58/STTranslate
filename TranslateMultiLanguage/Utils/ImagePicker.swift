//
//  ImagePicker.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 7/1/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit
import AVFoundation

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var completedClosure: ((UIImage) -> Void)?
    var resize = CGSize.zero
    static let sharedInstance = ImagePicker()
    let imagePicker = UIImagePickerController()
    var isEdit = false
    
    func pickImageWithPreferedCameraDevice(_ device: UIImagePickerControllerCameraDevice, parent: UIViewController, sourceView: UIView? = nil, resize: CGSize, completedClosure: ((UIImage) -> Void)?) {
        
        imagePicker.delegate = self
        self.completedClosure = completedClosure
        self.resize = resize
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                switch status {
                case .denied:
                    let alert = Utils.showAlertDefault(nil, message: "Please enable Camera access in app's setting to using this feature", buttons: ["Ok"], completed: { index in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL.init(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                    })
                    parent.present(alert, animated: true, completion: nil)
                    return
                case .authorized:
                    break
                default:
                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { (success) in
                        if !success {
                            let alert = Utils.showAlertDefault(nil, message: "Something went wrong. Please try again later.", buttons: ["Ok"], completed: { [weak self] (index) in
                                self?.imagePicker.dismiss(animated: true, completion: nil)
                            })
                            parent.present(alert, animated: true, completion: nil)
                        }
                    }
                }
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraDevice = device
                self.imagePicker.showsCameraControls = true
                self.imagePicker.allowsEditing = self.isEdit
                parent.present(self.imagePicker, animated: true, completion: nil)
            } else {
                let alert = Utils.showAlertDefault(nil, message: "Your device doesn't have camera", buttons: ["Ok"], completed: nil)
                parent.present(alert, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Thư viện ảnh", comment: ""), style: UIAlertActionStyle.default, handler: { (action) in
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.imagePicker.allowsEditing = self.isEdit
            parent.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Đóng", comment: ""), style: UIAlertActionStyle.cancel, handler: { (action) in
            //
        }))
        
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            if let view = sourceView {
                alert.popoverPresentationController?.sourceView = view
                alert.popoverPresentationController?.sourceRect = view.bounds
            }
        }
        parent.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = UIImage()
        if isEdit {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        } else {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        self.isEdit = false
        if picker.sourceType == .camera {
            UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage] as! UIImage, self, nil, nil)
        }
        picker.dismiss(animated: false) { [weak self] in
            self?.completedClosure?(image)
        }
    }
    
    // MARK: - Resize image
    
    func resizeImage(_ image: UIImage, size: CGSize) -> UIImage {
        let ratio = image.size.height / image.size.width
        let resize = CGSize(width: 150, height: 150 * ratio)
        UIGraphicsBeginImageContextWithOptions(resize, true, 0.0)
        image.draw(in: CGRect(origin: CGPoint.zero, size: resize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
}

