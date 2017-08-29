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
    private var leftBarItem: UIBarButtonItem!
    private var rightBarItem: UIBarButtonItem!
    private var titleView: UIButton!
    private lazy var indicatorView: NavigationIndicatorView = {
        let view = NavigationIndicatorView.instanceFromNib()
        view!.translatesAutoresizingMaskIntoConstraints = false
        return view!
    }()
    fileprivate var viewControllersArray: [UIViewController]!
    
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
        
        view.addSubview(indicatorView)
        view.addConstraint(NSLayoutConstraint(
            item: indicatorView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: view,
            attribute: .leading,
            multiplier: 1.0,
            constant: 0.0
        ))
        view.addConstraint(NSLayoutConstraint(
            item: indicatorView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: view,
            attribute: .trailing,
            multiplier: 1.0,
            constant: 0.0
        ))
        view.addConstraint(NSLayoutConstraint(
            item: indicatorView,
            attribute: .top,
            relatedBy: .equal,
            toItem: view,
            attribute: .top,
            multiplier: 1.0,
            constant: 0.0
        ))
        view.addConstraint(NSLayoutConstraint(
            item: indicatorView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: 5.0
        ))
    }
    
    private func setupNavigationBar() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.layer.shadowOffset = CGSize(width: 0, height: 5)
        navBar.layer.shadowRadius = 0
        navBar.layer.shadowOpacity = 0.1
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        
        leftBarItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_camera_alt").withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(tappedOnNavBarItem(sender:))
        )
        
        rightBarItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_photo").withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(tappedOnNavBarItem(sender:))
        )
        
        titleView = UIButton(type: .system)
        titleView.setImage(#imageLiteral(resourceName: "ic_palette"), for: .normal)
        titleView.addTarget(self, action: #selector(tappedOnNavBarItem(sender:)), for: .touchUpInside)
        
        leftBarItem.tag = 0
        titleView.tag = 1
        rightBarItem.tag = 2
        
        navigationItem.setLeftBarButton(leftBarItem, animated: true)
        navigationItem.setRightBarButton(rightBarItem, animated: true)
        navigationItem.titleView = titleView
    }
    
    @objc private func tappedOnNavBarItem(sender: UIView) {
        guard let currentVC = self.viewControllers?.first,
            let currentIndex = self.viewControllersArray.index(of: currentVC),
            let page = page(rawValue: sender.tag) else { return }
        
        let direction: UIPageViewControllerNavigationDirection = currentIndex < sender.tag ? .forward : .reverse
        scroll(to: page, direction: direction)
    }
    
    private func scroll(to page: page, direction: UIPageViewControllerNavigationDirection, savedPalette: Bool = false) {
        self.setViewControllers([viewControllersArray[page.rawValue]],
                                direction: direction,
                                animated: true,
                                completion: { complete in
                                    if complete {
                                        self.highlightNavBarItem(at: page.rawValue)
                                        if savedPalette, let palettesViewController = self.viewControllersArray[page.rawValue] as? PalettesViewController {
                                            palettesViewController.scrollToTop()
                                            self.store.userSavedPalette()
                                        }
                                    }
        })
    }
    
    fileprivate func highlightNavBarItem(at index: Int) {
        guard let page = page(rawValue: index),
            let position = NavigationIndicatorView.position(rawValue: index) else { return }
        UIView.animate(withDuration: 0.25, animations: {
            switch page {
            case .camera:
                self.leftBarItem.tintColor = .black
                self.titleView.tintColor = .lightGray
                self.rightBarItem.tintColor = .lightGray
            case .palettes:
                self.leftBarItem.tintColor = .lightGray
                self.titleView.tintColor = .black
                self.rightBarItem.tintColor = .lightGray
            case.inspiration:
                self.leftBarItem.tintColor = .lightGray
                self.titleView.tintColor = .lightGray
                self.rightBarItem.tintColor = .black
            default:
                break
            }
        })
        self.indicatorView.scroll(to: position)
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
        guard let currentVC = viewControllers?.first,
            let currentIndex = viewControllersArray.index(of: currentVC) else { return }
        
        highlightNavBarItem(at: currentIndex)
    }
}

