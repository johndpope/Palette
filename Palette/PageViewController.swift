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
    fileprivate lazy var titleView: NavigationTitleView? = {
        return NavigationTitleView.instanceFromNib() as? NavigationTitleView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setupViews()
        setupNavigationBar()
        setViewControllers([viewControllersArray[1]], direction: .forward, animated: true, completion: nil)
    }
    
    private func setupViews() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let cameraViewController = storyBoard.instantiateViewController(withIdentifier: "CameraView") as! CameraViewController
        
        let inspirationViewController = storyBoard.instantiateViewController(withIdentifier: "InspirationView") as! InspirationViewController
        let palettesViewController = storyBoard.instantiateViewController(withIdentifier: "PaletteView") as! PalettesViewController
        
        cameraViewController.didSavePalette = {
            self.setViewControllers([palettesViewController], direction: .forward, animated: true, completion: { finished in
                if finished {
                    palettesViewController.scrollToTop()
                    self.titleView?.scroll(direction: .forward, to: 1)
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
                                            self.titleView?.scroll(direction: .reverse, to: 1)
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
                                            self.titleView?.scroll(direction: .reverse, to: 0)
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
                                            self.titleView?.scroll(direction: .forward, to: 2)
                                        }
            })
        }
        
        viewControllersArray = [cameraViewController, palettesViewController, inspirationViewController]
    }

    private func setupNavigationBar() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        navBar.layer.shadowRadius = 0
        navBar.layer.shadowOpacity = 0.1

        navigationItem.titleView = titleView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let vc = viewControllers?.first,
            let index = viewControllersArray.index(of: vc) {
            titleView?.highlightIcon(at: index)
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex =  viewControllersArray.index(of: viewController)!-1
        if currentIndex < 0 {
            return nil
        }
        return viewControllersArray[currentIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex =  viewControllersArray.index(of: viewController)!+1
        if currentIndex >= viewControllersArray.count {
            return nil
        }
        return viewControllersArray[currentIndex]
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let titleView = self.titleView,
            let previousVC = previousViewControllers.first,
            let previousIndex = viewControllersArray.index(of: previousVC),
            let currentVC = viewControllers?.first,
            let currentIndex = viewControllersArray.index(of: currentVC),
            currentIndex != previousIndex else { return }
        
        titleView.scroll(direction: currentIndex > previousIndex ? .forward : .reverse, to: currentIndex)
    }
}
