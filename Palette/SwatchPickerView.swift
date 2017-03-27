//
//  swatchPickerView.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-23.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

class SwatchPickerView: UIView {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var swatchPickerImageView: UIImageView!
    var snapshot: UIImage?
    var context: CGContext?
    var currentColor: UIColor?
    
    func updateSwatchPickerLocations(_ touch: UITouch) {
        let locationOfTouch: CGPoint = touch.location(in: self)
        swatchPickerImageView.center = locationOfTouch
    }
    
    func colorAtPickerLocation() -> UIColor {
        let location = swatchPickerImageView.center
        if let snapshot = snapshot, let context = context {
            return snapshot.getPixelColor(location, context: context)
        } else {
            self.snapshot = photoImageView.takeSnapshot()
            self.context = self.snapshot!.createBitmap()
            return snapshot!.getPixelColor(location, context: context!)
        }
    }
}
