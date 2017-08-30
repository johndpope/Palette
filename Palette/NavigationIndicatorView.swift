//
//  NavigationIndicatorView.swift
//  Palette
//
//  Created by Alex Mathers on 2017-08-29.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

final class NavigationIndicatorView: UIView {
    enum position: Int {
        case left
        case center
        case right
    }
    
    @IBOutlet private weak var indicatorView: UIView!
    @IBOutlet private weak var horizontalConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    
    private lazy var iconOffset: CGFloat = {
        return self.frame.width / 2.0
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.layer.cornerRadius = indicatorView.frame.height / 2.0
    }
    
    func scroll(to position: position) {
        var offset: CGFloat = 0.0
        var width: CGFloat = 65.0
        switch position {
        case .left:
            offset = -iconOffset + width / 2.0 - indicatorView.layer.cornerRadius
        case .center:
            width = #imageLiteral(resourceName: "ic_palette").size.width * 1.5
        case .right:
            offset = iconOffset - width / 2.0 + indicatorView.layer.cornerRadius
        }
        
        horizontalConstraint.constant = offset
        widthConstraint.constant = width
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseIn,
                       animations: {
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    class func instanceFromNib() -> NavigationIndicatorView? {
        let nib = UINib(nibName: "NavigationIndicatorView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
        for view in nib {
            if let view = view as? NavigationIndicatorView {
                return view
            }
        }
        return nil
    }
}
