//
//  ViewController.swift
//  Palette1.0
//
//  Created by Alexander Mathers on 2016-02-22.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit

class SwatchPickerViewController: UIViewController {
    
    var mainImage: UIImage?
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var swatchStackView: UIStackView!
    @IBOutlet private weak var magnifyingView: YPMagnifyingView!
    @IBOutlet private weak var swatchPickerView: SwatchPickerView!
    @IBOutlet private weak var addSwatchButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    
    fileprivate var swatchArray = [UIColor]()
    fileprivate var mag: YPMagnifyingGlass!
    
    var didSavePalette: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews() {
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        headerView.layer.shadowRadius = 0
        headerView.layer.shadowOpacity = 0.1
        
        mag = YPMagnifyingGlass(frame: CGRect(
            x: magnifyingView.frame.origin.x,
            y: magnifyingView.frame.origin.y,
            width: 60,
            height: 60
        ))
        mag.viewToMagnify = self.swatchPickerView.photoImageView
        magnifyingView.magnifyingGlass = mag
        magnifyingView.touchesRecieved = { touch in
            self.swatchPickerView.updateSwatchPickerLocations(touch)
            self.addSwatchButton.tintColor = self.swatchPickerView.colorAtPickerLocation()
        }
        
        if let image = mainImage {
            swatchPickerView.photoImageView.image = image
        }
        
        addSwatchButton.tintColor = swatchPickerView.colorAtPickerLocation()
        
        saveButton.isEnabled = false
        
        containerView.layer.cornerRadius = 9
    }
    
    private func addSwatchToCollection(_ swatch:UIColor) {
        swatchArray.append(swatch)
        let newSwatchView: UIView = UIView()
        newSwatchView.backgroundColor = swatch
        swatchStackView.addArrangedSubview(newSwatchView)
    }
    
    @IBAction func addSwatch() {
        addSwatchToCollection(swatchPickerView.colorAtPickerLocation())
        saveButton.isEnabled = self.swatchArray.count > 0
    }
    
    @IBAction private func removeSwatch(_ sender: AnyObject) {
        if swatchArray.count > 0 {
            swatchArray.removeLast()
            let subview: UIView? = swatchStackView.arrangedSubviews.last!
            swatchStackView.removeArrangedSubview(subview!)
            subview!.removeFromSuperview()
        }
        saveButton.isEnabled = self.swatchArray.count > 0
    }
    
    @IBAction private func cancelButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveButton(_ sender: AnyObject) {
        // use date to get unique filename and save image
        let date = Date().timeIntervalSince1970
        let jpgData = UIImageJPEGRepresentation(mainImage!, 1.0)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("\(date).jpg")
        try? jpgData?.write(to: fileURL, options: [.atomic])
        
        // create palette object
        let newPalette = Palette(colors: swatchArray, image: "\(date).jpg")
        let encodedPalette = NSKeyedArchiver.archivedData(withRootObject: newPalette)

        // save palette object to palettesArray in user defaults
        let defaults = UserDefaults.standard
        if var palettesArray: [Data] = defaults.object(forKey: "palettesArray") as? [Data] {
            palettesArray.insert(encodedPalette, at: 0)
            defaults.set(palettesArray, forKey: "palettesArray")
        } else {
            var palettesArray: [Data]!
            palettesArray = [encodedPalette]
            defaults.set(palettesArray, forKey: "palettesArray")
        }
        
        defaults.synchronize()
        dismiss(animated: true, completion: self.didSavePalette)
    }
}




