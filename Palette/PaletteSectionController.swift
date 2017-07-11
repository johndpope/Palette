//
//  PaletteSectionController.swift
//  Palette
//
//  Created by Alex Mathers on 2017-07-07.
//  Copyright © 2017 Malecks. All rights reserved.
//

import UIKit
import IGListKit

final class PaletteSectionController: ListSectionController {
    var palette: Palette!
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return .zero }
        return CGSize(
            width: context.containerSize.width - inset.left - inset.right,
            height: 70
        )
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCellFromStoryboard(
            withIdentifier: "PaletteCell",
            for: self,
            at: index
            ) as! PaletteCollectionViewCell
        cell.layer.cornerRadius = 9
        cell.setup(with: palette)
        return cell
    }
    
    override func didUpdate(to object: Any) {
        palette = object as? Palette
    }
}
