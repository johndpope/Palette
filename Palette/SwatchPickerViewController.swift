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
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var swatchStackView: UIStackView!
    @IBOutlet private weak var magnifyingView: YPMagnifyingView!
    @IBOutlet private weak var swatchPickerView: SwatchPickerView!
    @IBOutlet private weak var addSwatchButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var pullDownImageView: UIImageView!
    
    fileprivate var swatchArray = [UIColor]()
    fileprivate var mag: YPMagnifyingGlass!
    
    var didSavePalette: (() -> ())?
    var interactor: Interactor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private func setUpViews() {
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
        pullDownImageView.layer.opacity = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, animations: {
            self.pullDownImageView.layer.opacity = 1.0
        })
    }
    
    private func addSwatchToCollection(_ swatch:UIColor) {
        swatchArray.append(swatch)
        let newSwatchView: UIView = UIView()
        newSwatchView.backgroundColor = swatch
        swatchStackView.addArrangedSubview(newSwatchView)
    }
    
    @IBAction func addSwatch() {
        addSwatchToCollection(swatchPickerView.colorAtPickerLocation())
        saveButton.isEnabled = swatchArray.count > 0
    }
    
    @IBAction private func removeSwatch(_ sender: AnyObject) {
        if swatchArray.count > 0 {
            swatchArray.removeLast()
            let subview: UIView? = swatchStackView.arrangedSubviews.last!
            swatchStackView.removeArrangedSubview(subview!)
            subview!.removeFromSuperview()
        }
        saveButton.isEnabled = swatchArray.count > 0
    } 
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        guard let interactor = interactor else { return }

        let percentThreshold: CGFloat = 0.3
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
    
    @IBAction private func didTapOutsideContainer(_ sender: Any) {
        self.confirmDismiss()
    }
    
    private func confirmDismiss() {
        if self.swatchArray.count > 0 {
            let alertController = UIAlertController(
                title: "Discard this Palette?",
                message: nil,
                preferredStyle: .alert
            )
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancel)
            
            let confirm = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(confirm)
            self.present(alertController, animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
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
        dismiss(animated: true, completion: self.didSavePalette)
    }
}




