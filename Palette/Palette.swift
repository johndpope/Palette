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
