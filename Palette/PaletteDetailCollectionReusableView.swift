//
//  PaletteDetailCollectionReusableView.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-03-01.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

final class PaletteDetailCollectionReusableView: UICollectionReusableView {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var stackView: UIStackView!
    
    @IBOutlet var containerView: UIView!
    
    func setup(with palette: Palette) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(palette.imageURL)
        if let data = try? Data(contentsOf: fileURL) {
            imageView.image = UIImage(data: data)
        }
        
        if stackView.arrangedSubviews.count > 0 {
            for view in stackView.arrangedSubviews {
                stackView.removeArrangedSubview(view)
            }
        }
        
        for color in palette.colors {
            let view = UIView()
            view.backgroundColor = color
            stackView.addArrangedSubview(view)
        }
    }
}
