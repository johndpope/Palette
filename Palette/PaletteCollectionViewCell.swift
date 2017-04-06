//
//  PaletteCollectionViewCell.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-29.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

final class PaletteCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var paletteStackView: UIStackView!
    
    func setup(with palette: Palette) {
        containerView.layer.cornerRadius = 6
        containerView.clipsToBounds = true

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
