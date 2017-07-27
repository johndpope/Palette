//
//  PaletteView.swift
//  Palette
//
//  Created by Alex Mathers on 2017-04-06.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

final class PaletteView: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(with palette: Palette) {
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
    
    class func instanceFromNib() -> PaletteView? {
        let nib = UINib(nibName: "PaletteView", bundle: nil).instantiate(withOwner: nil, options: nil)
        for view in nib {
            if let view = view as? PaletteView {
                return view
            }
        }
        return nil
    }
}
