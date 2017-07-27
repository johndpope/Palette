//
//  InspirationEmptyView.swift
//  PALette
//
//  Created by Alex Mathers on 2017-03-14.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit

class InspirationEmptyView: UIView {
    
    @IBOutlet private weak var containerView: UIView!
    
    var buttonAction: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 9
    }

    @IBAction private func didTapMainButton(_ sender: Any) {
        buttonAction?()
    }
    
    class func instanceFromNib() -> InspirationEmptyView? {
        let nib = UINib(nibName: "InspirationEmptyView", bundle: nil).instantiate(withOwner: nil, options: nil)
        for view in nib {
            if let view = view as? InspirationEmptyView {
                return view
            }
        }
        return nil
    }
    
}
