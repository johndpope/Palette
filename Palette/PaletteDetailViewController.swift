//
//  PaletteDetailViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-03-01.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import MBProgressHUD

final class PaletteDetailViewController: UIViewController {
    
    @IBOutlet fileprivate var paletteDetailCollectionView: UICollectionView!
    
    private let store = AppDefaultsManager()
    
    var palette: Palette?
    var paletteIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.userVisited(page: .detailPalette)
    }
    
    private func setupView() {
        guard let palette = palette, let colors = palette.colors else { return }
        if colors.count > 0 {
            let randomNum: Int = Int(arc4random_uniform(UInt32(colors.count)))
            let randomColour = colors[randomNum]
            let backgroundView = UIImageView(frame: view.frame)
            let backgroundImage = UIImage().createBackgroundImageWithColor(randomColour)
            backgroundView.image = backgroundImage
            view.insertSubview(backgroundView, at: 0)
        }
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


extension PaletteDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let palette = palette else { return 0 }
        return palette.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PaletteDetailCollectionViewCell", for: indexPath) as! PaletteDetailCollectionViewCell
        
        if let palette = palette {
            cell.setup(with: palette.colors[indexPath.row])
        }
        cell.layer.cornerRadius = cell.frame.size.height / 2.0
        return cell
    }
}

extension PaletteDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView!
        
        if (kind == UICollectionElementKindSectionHeader) {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader,
                withReuseIdentifier: "PaletteDetailCollectionReusableView",
                for: indexPath) as! PaletteDetailCollectionReusableView
            
            if let palette = palette {
                view.setup(with: palette)
            }
            reusableView = view
        }
        
        if (kind == UICollectionElementKindSectionFooter) {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionFooter,
                withReuseIdentifier: "PaletteDetailCollectionFooterView",
                for: indexPath) as! PaletteDetailCollectionFooterView
            
            view.containerView.layer.cornerRadius = view.containerView.frame.size.height / 2.0
            reusableView = view
        }
        
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let palette = palette else { return }
        let color = palette.colors[indexPath.row]
        let colorString = "\(color.hexString()) \(color.rgbString())"
        
        UIPasteboard.general.string = colorString
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = .text
        
        hud.label.font = UIFont(name: "Menlo", size: 15)!
        hud.label.text = "\(colorString)"
        
        hud.detailsLabel.font = UIFont(name: "Menlo", size: 12)!
        hud.detailsLabel.text = "copied to clipboard"
        
        hud.hide(animated: true, afterDelay: 1)
    }
}

extension PaletteDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let availableWidthForCells: CGFloat = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing
        let itemSize = CGSize(width: availableWidthForCells, height: flowLayout.itemSize.height)
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let flowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let availableWidthForCells: CGFloat =
            collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing
        return CGSize(
            width: availableWidthForCells,
            height: availableWidthForCells + 80
        )
    }
}
