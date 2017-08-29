//
//  PaletteDetailViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-03-01.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import IGListKit

final class PaletteDetailViewController: UIViewController {
    
    @IBOutlet fileprivate var paletteDetailCollectionView: UICollectionView!
    private let store = AppDefaultsManager()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var palette: Palette?
    var paletteIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paletteDetailCollectionView.collectionViewLayout = ListCollectionViewLayout(
            stickyHeaders: false,
            topContentInset: 0.0,
            stretchToEdge: false
        )
        paletteDetailCollectionView.contentInset.top = 20
        adapter.collectionView = paletteDetailCollectionView
        adapter.dataSource = self
        
        setupView()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.userVisited(page: .detailPalette)
    }
    
    private func setupView() {
        guard let palette = palette, let colors = palette.colors, colors.count > 0 else { return }
        let randomNum: Int = Int(arc4random_uniform(UInt32(colors.count)))
        let randomColour = colors[randomNum]
        let backgroundView = UIImageView(frame: view.frame)
        let backgroundImage = UIImage().createBackgroundImageWithColor(randomColour)
        backgroundView.image = backgroundImage
        view.insertSubview(backgroundView, at: 0)
    }
    
    private func setupNavigationBar() {
        let shareButton = UIBarButtonItem.init(
            image: UIImage(named: "ic_open_in_new"),
            style: .plain,
            target: self,
            action: #selector(shareButtonPressed)
        )
        
        navigationItem.setRightBarButton(shareButton, animated: true)
    }
    
    @IBAction private func didTapDeleteButton() {
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
                self.deletePalette()
                self.navigationController?.popToRootViewController(animated: true)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func deletePalette() {
        guard let palette = palette, let index = paletteIndex else { return }
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
    
    @objc private func shareButtonPressed() {
        guard let snapshot = palette?.shareableImage() else { return }
        
        let activityVC = UIActivityViewController(activityItems: [snapshot], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

extension PaletteDetailViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let palette = palette else { return [] }
        return [palette]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return PaletteDetailSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
