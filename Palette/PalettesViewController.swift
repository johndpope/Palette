//
//  MainViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-25.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import StoreKit
import IGListKit

final class PalettesViewController: UIViewController {
    private let store = AppDefaultsManager()

    @IBOutlet fileprivate var paletteCollectionView: UICollectionView!
    fileprivate var palettes: Array<Palette> = []
    
    let emptyView: PalettesEmptyView = {
        let view = PalettesEmptyView.instanceFromNib()
        return view as! PalettesEmptyView
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var showCameraView: (() -> ())?
    var showInspirationView: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paletteCollectionView.collectionViewLayout = ListCollectionViewLayout(
            stickyHeaders: false,
            topContentInset: 0.0,
            stretchToEdge: false
        )
        paletteCollectionView.contentInset.top = 20
    
        adapter.collectionView = paletteCollectionView
        adapter.dataSource = self
        setupView()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        palettes = store.getPalettesArray()
        adapter.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.userVisited(page: .palettes)
        requestReview()
    }
    
    private func setupView () {
        emptyView.cameraButtonAction = {
            self.showCameraView?()
        }
        
        emptyView.inspirationButtonAction = {
            self.showInspirationView?()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPaletteDetail" || segue.identifier == "ShowPaletteDetailPreview" {
            if let dvc = segue.destination as? PaletteDetailViewController {
                guard let cell = sender as? PaletteCollectionViewCell,
                    let indexPath = paletteCollectionView.indexPath(for: cell) else {
                        return
                }
                
                dvc.palette = palettes[indexPath.section]
                dvc.paletteIndex = indexPath.section
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
    
    fileprivate func deletePalette(palette: Palette, at index: Int) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(palette.imageURL)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
        
        // delete palette object from array
        let defaults = UserDefaults.standard
        if var encodedArray = defaults.object(forKey: "palettesArray") as? [Data] {
            encodedArray.remove(at: index)
            defaults.set(encodedArray, forKey: "palettesArray")
        }
    }
    
    private func requestReview() {
        guard store.detailPalettePageVisits != 0,
            store.didSavePaletteThisSession,
            #available(iOS 10.3, *) else { return }
        
        if let lastRequest = store.dateOfLastReviewRequest {
            let interval = 60.0 * 60.0 * 24.0 * 7.0 //1 Week
            let now = Date()
            
            guard now.timeIntervalSince(lastRequest as Date) >= interval else { return }
        }
        
        SKStoreReviewController.requestReview()
        store.requestedReview()
    }
}

extension PalettesViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return palettes
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PaletteSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyView
    }
}

extension PalettesViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = paletteCollectionView.indexPathForItem(at: paletteCollectionView.convert(location, from: view)),
            let cell = paletteCollectionView.cellForItem(at: indexPath),
            let viewController = storyboard?.instantiateViewController(withIdentifier: "PaletteDetailPeekViewController") as? PaletteDetailPeekViewController else { return nil }
        
        viewController.palette = palettes[indexPath.section]
        viewController.paletteIndex = indexPath.section
        
        viewController.shareAction = {
            guard let snapshot = self.palettes[indexPath.section].shareableImage() else { return }
            let activityVC = UIActivityViewController(activityItems: [snapshot], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        
        viewController.deleteAction = {
            let alertController = UIAlertController(
                title: "Delete Palette",
                message: "Are you sure you want to delete this pretty palette? You can't undo this.",
                preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(
                title: "Cancel",
                style: .cancel,
                handler: nil
            ))
            
            alertController.addAction(UIAlertAction(
                title: "Delete",
                style: .destructive,
                handler: { action in
                    self.deletePalette(palette: self.palettes[indexPath.section], at: indexPath.section)
                    self.palettes.remove(at: indexPath.section)
                    self.adapter.performUpdates(animated: true)
                    
                    self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        viewController.preferredContentSize = CGSize(width: 355, height: 405)
        previewingContext.sourceRect = paletteCollectionView.convert(cell.frame, to: paletteCollectionView.superview!)
        
        return viewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        guard let viewController = viewControllerToCommit as? PaletteDetailPeekViewController,
            let detailViewController = storyboard?.instantiateViewController(withIdentifier: "PaletteDetailViewController") as? PaletteDetailViewController else { return }
        detailViewController.palette = viewController.palette
        detailViewController.paletteIndex = viewController.paletteIndex
        
        show(detailViewController, sender: self)
    }
}
