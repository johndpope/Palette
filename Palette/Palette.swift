//
//  Palette.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-29.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import IGListKit

final class Palette: NSObject, NSCoding {
    private static let colorsKey = "colors"
    private static let imageURLKey = "imageURL"
    private static let diffIdKey = "diffId"
    
    fileprivate var diffId: NSNumber!

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
        self.colors = decoder.decodeObject(forKey: Palette.colorsKey) as? [UIColor] ?? []
        self.imageURL = decoder.decodeObject(forKey: Palette.imageURLKey) as? String ?? ""
        self.diffId = decoder.decodeObject(forKey: Palette.diffIdKey) as? NSNumber ?? Date().timeIntervalSince1970 as NSNumber
    }
    
    func encode(with aCoder:NSCoder) {
        aCoder.encode(self.colors, forKey: Palette.colorsKey)
        aCoder.encode(self.imageURL, forKey: Palette.imageURLKey)
        aCoder.encode(self.diffId, forKey: Palette.diffIdKey)
    }
}


extension Palette {
    func shareableImage() -> UIImage? {
        guard let view = PaletteView.instanceFromNib() else { return nil }
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

extension Palette: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.diffId
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? Palette {
            return colors == object.colors && imageURL == object.imageURL
        }
        return false
    }
}
