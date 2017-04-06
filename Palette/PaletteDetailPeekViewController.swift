//
//  PaletteDetailPeekViewController.swift
//  Palette
//
//  Created by Alex Mathers on 2017-03-29.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

final class PaletteDetailPeekViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    
    var palette: Palette?
    var shareAction: (() -> ())?
    var deleteAction: (() -> ())?
    
    private lazy var paletteView: PaletteView = {
        let view = PaletteView.instanceFromNib()
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view as! PaletteView
    }()
    
    lazy var previewActions: [UIPreviewActionItem] = {
        let shareAction = UIPreviewAction(title: NSLocalizedString("Share Palette", comment: ""), style: .default, handler: { (previewAction, viewController) -> Void in
            self.shareAction?()
        })
        
        let deleteAction = UIPreviewAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive, handler: { (previewAction, viewController) -> Void in
            self.deleteAction?()
        })
        
        return [shareAction, deleteAction]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        guard let palette = palette else { return }
        
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
        
        containerView.layer.cornerRadius = 9
        containerView.clipsToBounds = true
    }
}
