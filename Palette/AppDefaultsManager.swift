//
//  AppDefaultsManager.swift
//  Palette
//
//  Created by Alex Mathers on 2017-06-18.
//  Copyright © 2017 Malecks. All rights reserved.
//

import Foundation

class AppDefaultsManager {
    private let defaults: UserDefaults
    
    private static let palettesArrayKey = "palettesArray"
    private static let savedPalettesCountKey = "savedPalettesCount"
    private static let savedPaletteThisSession = "savedPaletteThisSession"
    
    private static let cameraPageVisits = "cameraPageVisits"
    private static let palettesPageVisits = "palettesPageVisits"
    private static let inspirationPageVisits = "inspirationPageVisits"
    private static let detailPalettePageVisits = "detailPalettePageVisits"
    
    private static let dateOfLastReviewRequest = "dateOfLastReviewRequest"
    private static let maxCount = 100000
    
    init() {
        defaults = UserDefaults.standard
    }
    
    /*
     `savedPalettesCount` is incremented every time a user saves a palette.
     It should never be de-incremented, and therefore differs from palettesArray().count,
     which will return the current number of saved palettes.
     */
    var savedPalettesCount: Int {
        get {
            return defaults.integer(forKey: AppDefaultsManager.savedPalettesCountKey)
        }
    }
    
    var didSavePaletteThisSession: Bool {
        get {
            return defaults.bool(forKey: AppDefaultsManager.savedPalettesCountKey)
        }
    }
    
    /*
     page visits are triggered in viewDidAppear for each controller
     */
    var cameraPageVisits: Int {
        get {
            return defaults.integer(forKey: AppDefaultsManager.cameraPageVisits)
        }
    }
    
    var palettesPageVisits: Int {
        get {
            return defaults.integer(forKey: AppDefaultsManager.palettesPageVisits)
        }
    }
    
    var inspirationPageVisits: Int {
        get {
            return defaults.integer(forKey: AppDefaultsManager.inspirationPageVisits)
        }
    }
    
    var detailPalettePageVisits: Int {
        get {
            return defaults.integer(forKey: AppDefaultsManager.detailPalettePageVisits)
        }
    }
    
    var dateOfLastReviewRequest: NSDate? {
        get {
            return defaults.value(forKey: AppDefaultsManager.dateOfLastReviewRequest) as? NSDate ?? nil
        }
    }
    
    func userSavedPalette() {
        defaults.set(true, forKey: AppDefaultsManager.savedPaletteThisSession)
        guard savedPalettesCount < AppDefaultsManager.maxCount else { return }
        defaults.set(savedPalettesCount + 1, forKey: AppDefaultsManager.savedPalettesCountKey)
    }
    
    func userVisited(page: page) {
        var pageKey: String
        switch page {
        case .camera: pageKey = AppDefaultsManager.cameraPageVisits
        case .palettes: pageKey = AppDefaultsManager.palettesPageVisits
        case .inspiration: pageKey = AppDefaultsManager.inspirationPageVisits
        case .detailPalette: pageKey = AppDefaultsManager.detailPalettePageVisits
        }
        
        let count = defaults.integer(forKey: pageKey)
        guard count < AppDefaultsManager.maxCount else { return }
        defaults.set(count + 1, forKey: pageKey)
    }
    
    func getPalettesArray() -> [Palette] {
        var palettes: [Palette] = []
        if let encodedArray = defaults.object(forKey: AppDefaultsManager.palettesArrayKey) as? [Data] {
            for data in encodedArray {
                if let palette: Palette = NSKeyedUnarchiver.unarchiveObject(with: data) as? Palette {
                    palettes.append(palette)
                }
            }
        }
        return palettes
    }
    
    func requestedReview() {
        defaults.set(Date(), forKey: AppDefaultsManager.dateOfLastReviewRequest)
    }
    
    func endUserSession() {
        defaults.set(false, forKey: AppDefaultsManager.savedPaletteThisSession)
    }
}
