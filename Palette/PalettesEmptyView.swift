//
//  PalettesEmptyView.swift
//  PALette
//
//  Created by Alex Mathers on 2017-03-21.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

final class PalettesEmptyView: UIView {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var titleImageView: UIImageView!
    
    var cameraButtonAction: (() -> ())?
    var inspirationButtonAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 9
        titleImageView.layer.cornerRadius = 9
    }

    @IBAction private func didTapCameraButton() {
        cameraButtonAction?()
    }
    
    
    @IBAction private func didTapInspirationButton() {
        inspirationButtonAction?()
    }
    
    class func instanceFromNib() -> PalettesEmptyView? {
        let nib = UINib(nibName: "PalettesEmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)
        for view in nib {
            if let view = view as? PalettesEmptyView {
                return view
            }
        }
        return nil
    }
}
