//
//  UITabBarController+.swift
//  Habbangine
//
//  Created by 윤제 on 5/30/24.
//  Copyright © 2024 HabbangineOrg. All rights reserved.
//

import UIKit

public protocol ResizableImage {}

extension ResizableImage {
    // 이미지 크기 조정 함수
    public func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine what scale factor to use
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        // Create a new image context
        UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, 0.0)
        
        // Draw the scaled image in the current context
        image.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        
        // Create a new UIImage from the context
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // Clean up the image context resources
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

extension NSObject: ResizableImage {}
