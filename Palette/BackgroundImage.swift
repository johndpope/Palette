//
//  BackgroundImage.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-25.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

extension UIImage {
    func createBackgroundImageWithColor(_ color:UIColor) -> UIImage? {
        let img = #imageLiteral(resourceName: "Background")
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        
        UIGraphicsBeginImageContextWithOptions(img.size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        img.draw(in: rect, blendMode: .screen, alpha: 1)
        
        // grab the finished image and return it
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
