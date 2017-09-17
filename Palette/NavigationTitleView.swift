//
//  NavigationTitleView.swift
//  Palette
//
//  Created by Alex Mathers on 2017-06-01.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

final class NavigationTitleView: UIView {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var leftIcon: UIImageView!
    @IBOutlet private weak var centerIcon: UIImageView!
    @IBOutlet private weak var rightIcon: UIImageView!
    @IBOutlet private weak var horizontalConstraint: NSLayoutConstraint!
    
    private lazy var icons: [UIImageView] = {
        return [self.leftIcon, self.centerIcon, self.rightIcon]
    }()
    
    lazy var iconOffset: CGFloat = {
        return (self.containerView.frame.width / 2.0) - (self.leftIcon.frame.width / 2.0)
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for icon in icons {
            icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = .lightGray
        }
    }

    func scroll(to index: Int) {
        guard index < icons.count else { return }
        
        var offset: CGFloat
        switch index {
        case 0: offset = iconOffset
        case 1: offset = 0
        case 2: offset = -iconOffset
        default: offset = 0
        }
        
        horizontalConstraint.constant = offset
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
            self.highlightIcon(at: index)
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func highlightIcon(at index: Int) {
        guard index < icons.count else { return }
        
        for (i, icon) in icons.enumerated() {
            icon.tintColor = i == index ? .black : .lightGray
        }
    }
    
    class func instanceFromNib() -> UIView? {
        let nib = UINib(nibName: "NavigationTitleView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)
        for view in nib {
            if let view = view as? NavigationTitleView {
                return view
            }
        }
        return nil
    }
}
