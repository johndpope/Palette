//
//  PatternView.swift
//  CircleBackground
//
//  Created by Alexander Mathers on 2016-02-11.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

@IBDesignable

class CirclePattern: UIView {
    let patternSize: CGFloat = 20
    let backGround: UIColor = UIColor(red: 36/255.0, green: 38/255.0, blue: 41/255.0, alpha: 1)
    let strokeColour: UIColor = UIColor(red: 31/255.0, green: 33/255.0, blue: 36/255.0, alpha: 1)
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!

        context.setFillColor(backGround.cgColor)
        context.fill(bounds)
        
        let drawSize = CGSize(width: patternSize, height: patternSize)
        
        UIGraphicsBeginImageContextWithOptions(drawSize, true, 0.0)
        let drawingContext = UIGraphicsGetCurrentContext()
        
        backGround.setFill()
        drawingContext?.fill(CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height))
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: patternSize, y: 0))
        path.addLine(to: CGPoint(x: 0, y: patternSize))
        strokeColour.setStroke()
        path.stroke()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIColor(patternImage: image!).setFill()
        context.fill(rect)
    }


}
