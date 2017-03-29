//
//  UIColor+valueExtension.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-03-01.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

extension UIColor {
    func hexString() -> String {
        
        guard let components = self.cgColor.components,
        components.count >= 3 else { return "" }
        let r = Int(components[0] * 255.0)
        let g = Int(components[1] * 255.0)
        let b = Int(components[2] * 255.0)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    
    func rgbString() -> String {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            //let iAlpha = Int(fAlpha * 255.0)
            
            let rgbString = "R:\(iRed) G:\(iGreen) B:\(iBlue)"
            return rgbString
        } else {
            return ""
        }
    }
}
