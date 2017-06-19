//
//  InsirationViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-24.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD
import DZNEmptyDataSet

class InspirationViewController: UIViewController {
    private let store = AppDefaultsManager()
    private let flikrAPIManager = FlikrAPIManager()
    private let SDDownloader = SDWebImageDownloader()
    private var progressHUD = MBProgressHUD()
    private var isLoading = false
    private var loadTimer: Timer?
    fileprivate var photosArray: [FlikrPhoto] = []
    
    fileprivate lazy var emptyView: InspirationEmptyView = {
        let view = InspirationEmptyView.instanceFromNib()
        view?.translatesAutoresizingMaskIntoConstraints = false
        return view as! InspirationEmptyView
    }()
    
    fileprivate lazy var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    @IBOutlet private var collectionView: UICollectionView!
    
    var didSavePalette: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        setupView()
        loadPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.userVisited(page: .inspiration)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentSwatchPicker" {
            guard let row = (sender as AnyObject).tag else {
                return
            }
            let cellAtIndex = collectionView.cellForItem(at: IndexPath(row: row, section: 0)) as! InspirationCollectionViewCell
            let dvc: SwatchPickerViewController = segue.destination as! SwatchPickerViewController
            dvc.mainImage = cellAtIndex.cellImageView.image
            dvc.didSavePalette = didSavePalette
        }
    }
    
    private func setupView() {
        emptyView.buttonAction = {
            self.loadPhotos()
        }
        
        progressHUD.frame = view.frame
        progressHUD.graceTime = 0.5
        progressHUD.minShowTime = 0.25
        progressHUD.isUserInteractionEnabled = true
        view.addSubview(progressHUD)
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(self.loadPhotos(append:)), for: .valueChanged)
    }
    
    @objc fileprivate func loadPhotos(append: Bool = false) {
        guard !isLoading, flikrAPIManager.pageNumber < flikrAPIManager.maxPage else { return }
        isLoading = true
        if !refreshControl.isRefreshing {
            progressHUD.show(animated: true)
        }
        flikrAPIManager.pageNumber = append ? flikrAPIManager.pageNumber + 1 : 1
        
        flikrAPIManager.retrievePhotos { photos, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.loadTimer = Timer.scheduledTimer(
                        timeInterval: 5.0,
                        target: self,
                        selector: #selector (self.resetIsLoading),
                        userInfo: nil,
                        repeats: false
                    )
                    self.progressHUD.hide(animated: true)
                    self.refreshControl.endRefreshing()
                }
                return
            }
            
            DispatchQueue.main.async {
                self.photosArray = append ? self.photosArray + photos : photos
                self.collectionView.reloadData()
                self.isLoading = false
                self.progressHUD.hide(animated: true)
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc fileprivate func resetIsLoading () {
        self.isLoading = false
        self.loadTimer?.invalidate()
    }
}

extension InspirationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InspirationCollectionViewCell
        cell.imageURLString = photosArray[indexPath.row].photoURL
        let url: URL = URL(string: cell.imageURLString)!
        let title: String = photosArray[indexPath.row].photoTitle
        
        cell.cellImageView.sd_setImage(with: url) // set cell image with SDWebImage
        cell.photoTitleLabel.text = title
        cell.tag = indexPath.row
        cell.layer.cornerRadius = 9
        
        return cell
    }
}

extension InspirationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - 1000 {
            loadPhotos(append: true)
        }
    }
}

extension InspirationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout: UICollectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let availableWidthForCells: CGFloat = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing
        let itemSize = CGSize(width: availableWidthForCells, height: availableWidthForCells+65)
        return itemSize
    }
}

extension InspirationViewController: DZNEmptyDataSetSource {

    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return emptyView
    }
    
}

extension InspirationViewController: DZNEmptyDataSetDelegate {

}
