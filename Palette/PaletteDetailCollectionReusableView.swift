//
//  PaletteDetailCollectionReusableView.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-03-01.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

final class PaletteDetailCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet private weak var containerView: UIView!
    private var paletteView: PaletteView?
    
    func setup(with palette: Palette) {
        containerView.layer.cornerRadius = 9
        containerView.clipsToBounds = true
        
        paletteView = PaletteView.instanceFromNib() as? PaletteView
        guard let view = paletteView else { return }
        view.frame = containerView.frame
        view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(view)
        
        containerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[paletteView]|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: ["paletteView" : view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[paletteView]|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: ["paletteView" : view]
        ))
        view.update(with: palette)
    }
}
