//
//  UIView+snapShotExtension.swift
//  Palette
//
//  Created by Alexander Mathers on 2016-02-22.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

extension UIView {
    
    func takeSnapshot(_ view: UIView) -> UIImage {
        var size: CGSize!
        if DeviceType.IS_IPHONE_6P {
            let width = view.bounds.size.width * 1.15
            let height = view.bounds.size.height * 1.15
            size = CGSize(width: width, height: height)
        } else {
            size = view.bounds.size
        }
        UIGraphicsBeginImageContextWithOptions(size, view.isOpaque, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
