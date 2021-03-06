//
//  AppDelegate.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-22.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    private var store = AppDefaultsManager()
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {        
        setupNavigationBars()
        
        print("Total Saved palettes count: \(store.savedPalettesCount)")
        print("Palettes visits: \(store.palettesPageVisits)")
        print("Inspiration visits: \(store.inspirationPageVisits)")
        print("Camera visits:\(store.cameraPageVisits)")
        print("Detail visits:\(store.detailPalettePageVisits)")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        store.endUserSession()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    private func setupNavigationBars() {
        if let font = UIFont(name: "Menlo", size: 16.0) {
            UINavigationBar.appearance().titleTextAttributes = [ NSAttributedStringKey.font: font]
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
        }
        UINavigationBar.appearance().tintColor = .black
    }
}

