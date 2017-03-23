//
//  MainViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-25.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class PalettesViewController: UIViewController {
    fileprivate var arrayOfPalettes: Array<Palette> = []
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpPalettes()
        paletteCollectionView.reloadData()
    }
    
    func setupView () {
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
        arrayOfPalettes = []
        let defaults = UserDefaults.standard
        if let encodedArray = defaults.object(forKey: "palettesArray") as? [Data] {
            for data in encodedArray {
                if let palette: Palette = NSKeyedUnarchiver.unarchiveObject(with: data) as? Palette {
                    arrayOfPalettes.append(palette)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPaletteDetail" {
            if let dvc = segue.destination as? PaletteDetailViewController {
                let cell = sender as! PaletteCollectionViewCell
                dvc.palette = cell.palette
                dvc.paletteIndex = paletteCollectionView.indexPath(for: cell)!.row
            }
        }
    }
    
    func scrollToTop() {
        guard arrayOfPalettes.count > 0 else { return }
        self.paletteCollectionView.scrollToItem(
            at: IndexPath(row: 0, section: 0),
            at: UICollectionViewScrollPosition.centeredVertically,
            animated: true
        )
    }
}

extension PalettesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfPalettes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaletteCell", for: indexPath) as! PaletteCollectionViewCell
        let palette = arrayOfPalettes[indexPath.row]
        
        cell.palette = palette
        cell.populatePalette()
        
        cell.layer.cornerRadius = 9
        cell.containerView.clipsToBounds = true
        cell.containerView.layer.cornerRadius = 4
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
