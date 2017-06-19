//
//  ViewController.swift
//  CustomCamera
//
//  Created by Alexander Mathers on 2016-02-25.
//  Copyright © 2016 Malecks. All rights reserved.
//

import UIKit
import CameraManager

class CameraViewController: UIViewController {
    
    @IBOutlet private weak var flashButton: UIButton!
    @IBOutlet private weak var galleryButton: UIButton!
    @IBOutlet private weak var shutterButton: UIButton!
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var buttonContainerView: UIView!
    
    private let store = AppDefaultsManager()
    private let cameraManager = CameraManager()
    private let picker = UIImagePickerController()
    
    var photo: UIImage?
    var didSavePalette: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setupCamera()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        store.userVisited(page: .camera)
    }

    private func setupCamera() {
        if cameraManager.addPreviewLayerToView(self.cameraView) == .ready {
            cameraManager.cameraDevice = .back
            cameraManager.cameraOutputMode = .stillImage
            cameraManager.cameraOutputQuality = .high
            cameraManager.writeFilesToPhoneLibrary = false
        }
    }
    
    private func setupView() {
        buttonContainerView.layer.cornerRadius = 9
        
        flashButton.layer.cornerRadius = 3
        flashButton.layer.borderWidth = 2
        
        updateFlashButton()
    }
    
    @IBAction private func shutter(_ sender: AnyObject) {
        cameraManager.capturePictureWithCompletion({ (image, error) -> Void in
            self.photo = image
            self.performSegue(withIdentifier: "presentSwatchPicker", sender: self)
        })
    }
    
    @IBAction private func gallery(_ sender: AnyObject) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction private func changeFlash(_ sender: AnyObject) {
        if cameraManager.hasFlash {
            cameraManager.flashMode = cameraManager.changeFlashMode()
        }
        updateFlashButton()
    }
    
    private func updateFlashButton () {
        if cameraManager.hasFlash {
            switch cameraManager.flashMode {
            case .on:
                flashButton.tintColor = UIColor.black
                flashButton.layer.borderColor = UIColor.black.cgColor
                flashButton.backgroundColor = UIColor.yellow
                flashButton.setTitle(".on", for: UIControlState())
            case .off:
                flashButton.tintColor = UIColor.lightGray
                flashButton.layer.borderColor = UIColor.lightGray.cgColor
                flashButton.backgroundColor = UIColor.white
                flashButton.setTitle(".off", for: UIControlState())
            case .auto:
                flashButton.tintColor = UIColor.black
                flashButton.layer.borderColor = UIColor.black.cgColor
                flashButton.backgroundColor = UIColor.white
                flashButton.setTitle(".auto", for: UIControlState())
            }
        } else {
            flashButton.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentSwatchPicker" {
            let dvc: SwatchPickerViewController = segue.destination as! SwatchPickerViewController
            dvc.didSavePalette = didSavePalette
            dvc.mainImage = photo!
        }
    }
}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage
        self.photo = chosenImage
        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "presentSwatchPicker", sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

