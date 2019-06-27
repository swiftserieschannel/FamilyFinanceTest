//
//  AddViewController.swift
//  FamilyFinanceTest
//
//  Created by ÇağkanTaştekin on 2019. 06. 25..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    //MARK:- STORED PROPERTIES
    var choosenImage:UIImage?
    
    //MARK: - LIFECYCLE CALLS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - INSTANCE METHODS
    func openCamera(){
        ImagePickerManager.shared.pickImageFromCamera(editing: true) { (image, error) in
            if error == nil{
                if image != nil {
                    self.choosenImage = image
                }
            }
        }
    }
    
    func chooseFromGallery(){
        ImagePickerManager.shared.pickImageFromPhotoLibrary(editing: true) { (image, error) in
            if error == nil{
                if image != nil {
                    self.choosenImage = image
                }
            }
        }
    }
    
    
    //MARK: - SCREEN ACTIONS
    @IBAction func chooseImage(_ sender: Any) {
        let Alertsheet = UIAlertController(title: "Choose From...", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.openCamera()
        })
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            self.chooseFromGallery()
        })
        let cancelAction = UIAlertAction(title: Alerts.kAlertCancel, style: .cancel, handler: { (action) in
        })
        
        Alertsheet.addAction(cameraAction)
        Alertsheet.addAction(galleryAction)
        Alertsheet.addAction(cancelAction)
        self.present(Alertsheet, animated: true)
    }
    
}
