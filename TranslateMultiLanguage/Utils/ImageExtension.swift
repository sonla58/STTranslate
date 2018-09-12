//
//  ImageExtension.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 7/2/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit

extension UIImage {
    
    func toGrayScale() -> UIImage {
        
        let greyImage = UIImageView()
        greyImage.image = self
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: greyImage.image!), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        greyImage.image = processedImage
        
        return greyImage.image!
    }
    
    func binarise() -> UIImage {
        
        let glContext = EAGLContext(api: .openGLES2)!
        let ciContext = CIContext(eaglContext: glContext, options: [kCIContextOutputColorSpace : NSNull()])
        let filter = CIFilter(name: "CIPhotoEffectMono")
        filter!.setValue(CIImage(image: self), forKey: "inputImage")
        let outputImage = filter!.outputImage
        let cgimg = ciContext.createCGImage(outputImage!, from: (outputImage?.extent)!)
        
        return UIImage(cgImage: cgimg!)
    }
    
    func scaleImage() -> UIImage {
        
        let maxDimension: CGFloat = 640
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if self.size.width > self.size.height {
            scaleFactor = self.size.height / self.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = self.size.width / self.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        self.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func orientate(img: UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
        
    }
    
}
