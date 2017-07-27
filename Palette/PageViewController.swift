//
//  PageViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-29.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

enum page: Int {
    case camera
    case palettes
    case inspiration
    case detailPalette
}

final class PageViewController: UIPageViewController {
    private let store = AppDefaultsManager()
    fileprivate var viewControllersArray: [UIViewController]!
    fileprivate let titleView: NavigationTitleView! = {
        return NavigationTitleView.instanceFromNib()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupViews()
        setupNavigationBar()
        scroll(to: .palettes, direction: .forward)
    }
    
    private func setupViews() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let cameraViewController = storyBoard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
        let inspirationViewController = storyBoard.instantiateViewController(withIdentifier: "InspirationView") as! InspirationViewController
        let palettesViewController = storyBoard.instantiateViewController(withIdentifier: "PaletteView") as! PalettesViewController
        
        cameraViewController.didSavePalette = {
            self.scroll(to: .palettes, direction: .forward, savedPalette: true)
        }
        
        inspirationViewController.didSavePalette = {
            self.scroll(to: .palettes, direction: .reverse, savedPalette: true)
        }
        
        palettesViewController.showCameraView = {
            self.scroll(to: .camera, direction: .reverse)
        }
        
        palettesViewController.showInspirationView = {
            self.scroll(to: .inspiration, direction: .forward)
        }
        
        viewControllersArray = [cameraViewController, palettesViewController, inspirationViewController]
    }

    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        navBar.layer.shadowRadius = 0
        navBar.layer.shadowOpacity = 0.1
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()

        navigationItem.titleView = titleView
        navigationItem.titleView?.isUserInteractionEnabled = true

        titleView.tappedAtIndex = { index in
            guard let currentVC = self.viewControllers?.first,
                let currentIndex = self.viewControllersArray.index(of: currentVC) else { return }
            
            let direction: UIPageViewControllerNavigationDirection = currentIndex < index ? .forward : .reverse
            self.setViewControllers(
                [self.viewControllersArray[index]],
                direction: direction,
                animated: true,
                completion: { completed in
                    self.titleView?.scroll(to: index)
            })
        }
    }
    
    func scroll(to page: page, direction: UIPageViewControllerNavigationDirection, savedPalette: Bool = false) {
        self.setViewControllers([viewControllersArray[page.rawValue]],
                                direction: direction,
                                animated: true,
                                completion: { complete in
                                    if complete {
                                        self.titleView.scroll(to: page.rawValue)
                                        if savedPalette, let palettesViewController = self.viewControllersArray[page.rawValue] as? PalettesViewController {
                                            palettesViewController.scrollToTop()
                                            self.store.userSavedPalette()
                                        }
                                    }
        })
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersArray.index(of: viewController),
            index - 1 >= 0 else { return nil }

        return viewControllersArray[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index =  viewControllersArray.index(of: viewController),
            index + 1 < viewControllersArray.count else { return nil }
        
        return viewControllersArray[index + 1]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let titleView = self.titleView,
            let currentVC = viewControllers?.first,
            let currentIndex = viewControllersArray.index(of: currentVC) else { return }
        
        titleView.scroll(to: currentIndex)
    }
}
