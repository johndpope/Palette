//
//  UIImage+pixelColorExtension.swift
//  Palette
//
//  Created by Alexander Mathers on 2016-02-21.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

extension UIImage {
    func createBitmap () ->  CGContext {
        let cgImage = self.cgImage
        let width = Int(size.width)
        let height = Int(size.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)!
        context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return context
    }
    
    func getPixelColor(_ point: CGPoint, context: CGContext) -> UIColor {
        let cgImage = self.cgImage        
        context.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        let pixelBuffer: UnsafeMutablePointer<UInt32> = (context.data?.bindMemory(to: UInt32.self, capacity: 255))!
        let pixel = pixelBuffer + Int(point.y) * Int(size.width) + Int(point.x)
        
        let r = CGFloat(red(pixel.pointee))   / CGFloat(255.0)
        let g = CGFloat(green(pixel.pointee)) / CGFloat(255.0)
        let b = CGFloat(blue(pixel.pointee))  / CGFloat(255.0)
        let a = CGFloat(alpha(pixel.pointee)) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    fileprivate func alpha(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 24) & 255)
    }
    
    fileprivate func red(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 16) & 255)
    }
    
    fileprivate func green(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 8) & 255)
    }
    
    fileprivate func blue(_ color: UInt32) -> UInt8 {
        return UInt8((color >> 0) & 255)
    }
    
//    fileprivate func rgba(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) -> UInt32 {
//        return (UInt32(alpha) << 24) | (UInt32(red) << 16) | (UInt32(green) << 8) | (UInt32(blue) << 0)
//    }
}
