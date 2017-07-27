//
//  PaletteDetailPhotoCell.swift
//  Palette
//
//  Created by Alex Mathers on 2017-07-26.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

final class PaletteDetailPhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var containerView: UIView!
    private var paletteView: PaletteView!
    
    func setup(with palette: Palette) {
        containerView.layer.cornerRadius = 9
        containerView.clipsToBounds = true
        
        paletteView = PaletteView.instanceFromNib()!
        paletteView.frame = containerView.frame
        paletteView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(paletteView)

        containerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[paletteView]|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: ["paletteView" : paletteView]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[paletteView]|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: ["paletteView" : paletteView]
        ))
        paletteView.update(with: palette)
    }
}
