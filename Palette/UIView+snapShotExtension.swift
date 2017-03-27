//
//  UIView+snapShotExtension.swift
//  Palette
//
//  Created by Alexander Mathers on 2016-02-22.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

extension UIView {
    func takeSnapshot(resize: Bool = true) -> UIImage {
        var size: CGSize!
        if DeviceType.IS_IPHONE_6P && resize {
            let width = self.bounds.size.width * 1.15
            let height = self.bounds.size.height * 1.15
            size = CGSize(width: width, height: height)
        } else {
            size = self.bounds.size
        }
        UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
