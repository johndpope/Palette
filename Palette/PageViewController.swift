//
//  PageViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-29.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    fileprivate var viewControllersArray: [UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.setupViews()
        self.setupNavigationBar()
        self.setViewControllers([self.viewControllersArray[1]], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupViews() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let cameraViewController = storyBoard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
        
        let inspirationViewController = storyBoard.instantiateViewController(withIdentifier: "InspirationView") as! InspirationViewController
        let palettesViewController = storyBoard.instantiateViewController(withIdentifier: "PaletteView") as! PalettesViewController
        
        cameraViewController.didSavePalette = {
            self.setViewControllers([palettesViewController], direction: .forward, animated: true, completion: { complete in
                if complete {
                    palettesViewController.scrollToTop()
                }
            })
        }
        
        inspirationViewController.didSavePalette = {
            self.setViewControllers([palettesViewController], direction: .reverse, animated: true, completion: { complete in
                if complete {
                    palettesViewController.scrollToTop()
                }
            })
        }
        
        palettesViewController.showCameraView = {
            self.setViewControllers([cameraViewController], direction: .reverse, animated: true, completion: nil)
        }
        
        palettesViewController.showInspirationView = {
            self.setViewControllers([inspirationViewController], direction: .forward, animated: true, completion: nil)
        }
        
        self.viewControllersArray = [cameraViewController, palettesViewController, inspirationViewController]
    }

    private func setupNavigationBar() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.tintColor = .black
        navBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        navBar.layer.shadowRadius = 0
        navBar.layer.shadowOpacity = 0.1
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex =  self.viewControllersArray.index(of: viewController)!-1
        if currentIndex < 0 {
            return nil
        }
        return self.viewControllersArray[currentIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex =  self.viewControllersArray.index(of: viewController)!+1
        if currentIndex >= self.viewControllersArray.count {
            return nil
        }
        return self.viewControllersArray[currentIndex]
    }
}
