//
//  MainViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-25.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

final class PalettesViewController: UIViewController {
    fileprivate var palettes: Array<Palette> = []
    @IBOutlet fileprivate var paletteCollectionView: UICollectionView!
    @IBOutlet private var headerView: UIView!
    
    fileprivate lazy var emptyView: PalettesEmptyView = {
        let view = PalettesEmptyView.instanceFromNib()
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view as! PalettesEmptyView
    }()
    
    var showCameraView: (() -> ())?
    var showInspirationView: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paletteCollectionView.emptyDataSetSource = self
        paletteCollectionView.emptyDataSetDelegate = self
        setupView()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpPalettes()
        paletteCollectionView.reloadData()
    }
    
    private func setupView () {
        emptyView.cameraButtonAction = {
            self.showCameraView?()
        }
        
        emptyView.inspirationButtonAction = {
            self.showInspirationView?()
        }
        
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        headerView.layer.shadowRadius = 0
        headerView.layer.shadowOpacity = 0.1
    }
    
    private func setUpPalettes () {
        palettes = []
        let defaults = UserDefaults.standard
        if let encodedArray = defaults.object(forKey: "palettesArray") as? [Data] {
            for data in encodedArray {
                if let palette: Palette = NSKeyedUnarchiver.unarchiveObject(with: data) as? Palette {
                    palettes.append(palette)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPaletteDetail" || segue.identifier == "ShowPaletteDetailPreview" {
            if let dvc = segue.destination as? PaletteDetailViewController {
                guard let cell = sender as? PaletteCollectionViewCell,
                    let indexPath = paletteCollectionView.indexPath(for: cell) else {
                        return
                }
                
                dvc.palette = palettes[indexPath.row]
                dvc.paletteIndex = indexPath.row
            }
        }
    }
    
    func scrollToTop() {
        guard palettes.count > 0 else { return }
        self.paletteCollectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0),
            at: UICollectionViewScrollPosition.centeredVertically,
            animated: true
        )
    }
}

extension PalettesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return palettes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaletteCell", for: indexPath) as! PaletteCollectionViewCell
        cell.layer.cornerRadius = 9
        cell.setup(with: palettes[indexPath.row])
        return cell
    }
}

extension PalettesViewController: UICollectionViewDelegate {
    
}

extension PalettesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let availableWidthForCells: CGFloat = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing
        let itemSize = CGSize(width: availableWidthForCells, height: flowLayout.itemSize.height)
        return itemSize
    }
}

extension PalettesViewController: DZNEmptyDataSetSource {
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return emptyView
    }
}

extension PalettesViewController: DZNEmptyDataSetDelegate {
    
}

extension PalettesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = paletteCollectionView.indexPathForItem(at: paletteCollectionView.convert(location, from: view)),
            let cell = paletteCollectionView.cellForItem(at: indexPath),
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PaletteDetailPeekViewController") as? PaletteDetailPeekViewController else { return nil }
        
        viewController.palette =  palettes[indexPath.row]
        viewController.preferredContentSize = CGSize(width: 355, height: 405)
        previewingContext.sourceRect = paletteCollectionView.convert(cell.frame, to: paletteCollectionView.superview!)
        
        return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let viewController = viewControllerToCommit as? PaletteDetailPeekViewController,
            let detailViewController = storyboard?.instantiateViewController(withIdentifier: "PaletteDetailViewController") as? PaletteDetailViewController else { return }
        detailViewController.palette = viewController.palette
        
        show(detailViewController, sender: self)
    }
}
