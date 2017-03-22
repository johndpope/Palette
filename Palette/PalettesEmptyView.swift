//
//  PalettesEmptyView.swift
//  PALette
//
//  Created by Alex Mathers on 2017-03-21.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

class PalettesEmptyView: UIView {

    @IBOutlet weak var containerView: UIView!
    
    var cameraButtonAction: (() -> ())?
    var inspirationButtonAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 9
    }

    @IBAction func didTapCameraButton() {
        cameraButtonAction?()
    }
    
    
    @IBAction func didTapInspirationButton() {
        inspirationButtonAction?()
    }
    
    
    class func instanceFromNib() -> UIView? {
        let nib = UINib(nibName: "PalettesEmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)
        for view in nib {
            if let view = view as? PalettesEmptyView {
                return view
            }
        }
        return nil
    }
}
