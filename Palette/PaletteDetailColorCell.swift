//
//  PaletteDetailColorCell.swift
//  Palette
//
//  Created by Alexander Mathers on 2016-03-01.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

final class PaletteDetailColorCell: UICollectionViewCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private var colorView: UIView!
    @IBOutlet private var hexLabel: UILabel!
    @IBOutlet private var RGBLabel: UILabel!
    
    func setup(with color: UIColor) {
        containerView.layer.cornerRadius = containerView.frame.size.height / 2.0
        colorView.layer.cornerRadius = colorView.frame.size.height / 2.0
        colorView.backgroundColor = color
        hexLabel.text = color.hexString()
        RGBLabel.text = color.rgbString()
    }
}
