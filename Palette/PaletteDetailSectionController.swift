//
//  PaletteDetailSectionController.swift
//  Palette
//
//  Created by Alex Mathers on 2017-07-26.
//  Copyright © 2017 Malecks. All rights reserved.
//

import Foundation
import IGListKit
import MBProgressHUD

final class PaletteDetailSectionController: ListSectionController {
    var palette: Palette!
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    override func numberOfItems() -> Int {
        return palette.colors.count + 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        let width = context.containerSize.width - inset.left - inset.right
        let height = index == 0 ? width + 80 : 70
        return CGSize(width: width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let identifier = index == 0 ? "PaletteDetailPhotoCell" : index < palette.colors.count + 1 ? "PaletteDetailColorCell" : "PaletteDetailDeleteCell"
        
        let cell: UICollectionViewCell = collectionContext!.dequeueReusableCellFromStoryboard(withIdentifier: identifier, for: self, at: index)
        
        if let cell = cell as? PaletteDetailPhotoCell {
            cell.setup(with: self.palette)
        } else if let cell = cell as? PaletteDetailColorCell {
            cell.setup(with: palette.colors[index - 1])
        } else if let cell = cell as? PaletteDetailDeleteCell {
            cell.containerView.layer.cornerRadius = cell.containerView.frame.size.height / 2.0
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        palette = object as? Palette
    }
    
    override func didSelectItem(at index: Int) {
        if index > 0 && index < palette.colors.count + 1 {
            let color = palette.colors[index - 1]
            let colorString = "\(color.hexString()) \(color.rgbString())"
            
            UIPasteboard.general.string = colorString
            
            let hud = MBProgressHUD.showAdded(to: self.viewController!.view, animated: true)
            hud.mode = .text
            
            hud.label.font = UIFont(name: "Menlo", size: 15)!
            hud.label.text = "\(colorString)"
            
            hud.detailsLabel.font = UIFont(name: "Menlo", size: 12)!
            hud.detailsLabel.text = "copied to clipboard"
            
            hud.hide(animated: true, afterDelay: 1)
        }
    }
}
