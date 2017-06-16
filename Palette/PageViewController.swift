//
//  PageViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-29.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

final class PageViewController: UIPageViewController {
    
    enum views: Int {
        case camera
        case palettes
        case inspiration
    }
    
    fileprivate var viewControllersArray: [UIViewController]!
    fileprivate lazy var titleView: NavigationTitleView? = {
        return NavigationTitleView.instanceFromNib() as? NavigationTitleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupViews()
        setupNavigationBar()
        setViewControllers([viewControllersArray[views.palettes.rawValue]], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupViews() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let cameraViewController = storyBoard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
        
        let inspirationViewController = storyBoard.instantiateViewController(withIdentifier: "InspirationView") as! InspirationViewController
        let palettesViewController = storyBoard.instantiateViewController(withIdentifier: "PaletteView") as! PalettesViewController
        
        cameraViewController.didSavePalette = {
            self.setViewControllers([palettesViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: { complete in
                                        if complete {
                                            palettesViewController.scrollToTop()
                                            self.titleView?.scroll(to: views.palettes.rawValue)
                                        }
            })
        }
        
        inspirationViewController.didSavePalette = {
            self.setViewControllers([palettesViewController],
                                    direction: .reverse,
                                    animated: true,
                                    completion: { complete in
                                        if complete {
                                            palettesViewController.scrollToTop()
                                            self.titleView?.scroll(to: views.palettes.rawValue)
                                        }
            })
        }
        
        palettesViewController.showCameraView = {
            self.setViewControllers([cameraViewController],
                                    direction: .reverse,
                                    animated: true,
                                    completion: { complete in
                                        if complete {
                                            palettesViewController.scrollToTop()
                                            self.titleView?.scroll(to: views.camera.rawValue)
                                        }
            })
        }
        
        palettesViewController.showInspirationView = {
            self.setViewControllers([inspirationViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: { complete in
                                        if complete {
                                            palettesViewController.scrollToTop()
                                            self.titleView?.scroll(to: views.inspiration.rawValue)
                                        }
            })
        }
        
        viewControllersArray = [cameraViewController, palettesViewController, inspirationViewController]
    }

    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        navBar.layer.shadowRadius = 0
        navBar.layer.shadowOpacity = 0.1
    
        guard let titleView = titleView else { return }
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
