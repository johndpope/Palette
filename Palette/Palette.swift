//
//  Palette.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-29.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

final class Palette: NSObject, NSCoding {
    var colors: [UIColor]!
    var imageURL: String!
    
    init (colors: Array<UIColor>, image: String) {
        self.colors = colors
        self.imageURL = image
    }
    
    override init() {
        super.init()
    }
    
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.colors = decoder.decodeObject(forKey: "colors") as! [UIColor]
        self.imageURL = decoder.decodeObject(forKey: "imageURL") as! String
    }
    
    func encode(with aCoder:NSCoder) {
        aCoder.encode(self.colors, forKey: "colors")
        aCoder.encode(self.imageURL, forKey: "imageURL")
    }
}


extension Palette {
    func shareableImage() -> UIImage? {
        guard let view = PaletteView.instanceFromNib() as? PaletteView else { return nil }
        view.frame = CGRect(x: 0, y: 0, width: 355, height: 415)
        view.update(with: self)
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, view.isOpaque, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
