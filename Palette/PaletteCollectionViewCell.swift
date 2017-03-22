//
//  PaletteCollectionViewCell.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-29.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

class PaletteCollectionViewCell: UICollectionViewCell {
    @IBOutlet var containerView: UIView!
    @IBOutlet var paletteStackView: UIStackView!
    var palette: Palette!
    
    func populatePalette () {
        for view in paletteStackView.subviews {
            paletteStackView.removeArrangedSubview(view)
        }
        
        for color in palette.colors {
            let view = UIView()
            view.backgroundColor = color
            paletteStackView.addArrangedSubview(view)
        }
    }
}
