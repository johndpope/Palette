//
//  PaletteDetailPeekViewController.swift
//  Palette
//
//  Created by Alex Mathers on 2017-03-29.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

final class PaletteDetailPeekViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var stackView: UIStackView!
    
    var palette: Palette?
    
    lazy var previewActions: [UIPreviewActionItem] = {
        let shareAction = UIPreviewAction(title: NSLocalizedString("Share Palette", comment: ""), style: .default, handler: { (previewAction, viewController) -> Void in
            
        })
        
        let deleteAction = UIPreviewAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (previewAction, viewController) -> Void in
            
        })
        
        return [shareAction, deleteAction]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        guard let palette = palette else { return }
        
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
        
        if let colors = palette.colors {
            if colors.count > 0 {
                let randomNum: Int = Int(arc4random_uniform(UInt32(colors.count)))
                let randomColour = colors[randomNum]
                let backgroundView = UIImageView(frame: view.frame)
                let backgroundImage = UIImage().createBackgroundImageWithColor(randomColour)
                backgroundView.image = backgroundImage
                view.insertSubview(backgroundView, at: 0)
            }
        }
    }
}
