//
//  NavigationCenterTitleView.swift
//  Palette
//
//  Created by Alex Mathers on 2017-08-30.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

final class NavigationCenterTitleView: UIView {
    @IBOutlet weak var titleButton: UIButton!
    var titleButtonAction: (() -> ())?
    
    @IBAction func didTapButton() {
        self.titleButtonAction?()
    }
    
    class func instanceFromNib() -> NavigationCenterTitleView? {
        let nib = UINib(nibName: "NavigationCenterTitleView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
        for view in nib {
            if let view = view as? NavigationCenterTitleView {
                return view
            }
        }
        return nil
    }
}
