//
//  AddViewController.swift
//  FamilyFinanceTest
//
//  Created by ÇağkanTaştekin on 2019. 06. 25..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    //MARK: - OUTLETS
    
    @IBOutlet weak var addIngredientsTableView: UITableView!
    @IBOutlet weak var addStepsTableView: UITableView!
    //MARK:- STORED PROPERTIES
    var choosenImage:UIImage?
    var numberOfRowsForAddIngredients:Int = 1
    var numberOfRowsForAddSteps:Int = 1
    //MARK: - LIFECYCLE CALLS
    override func viewDidLoad() {
        super.viewDidLoad()
        addIngredientsTableView.dataSource = self
        addIngredientsTableView.delegate = self
        addStepsTableView.dataSource = self
        addStepsTableView.delegate = self
        //
        //self.addIngredientsTableView.register(AddIngredientsHeaderCell.self, forCellReuseIdentifier: "AddIngredientsHeaderCell")
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

//MARK: - EXTENSION FOR INGREDIENTS TABLE VIEW DATA SOURCE
extension AddViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  numberOfRowsForAddIngredients
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "AddIngredientsHeaderCell")! as! AddIngredientsHeaderCell
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddIngredientsTableViewCell") as? AddIngredientsTableViewCell
        
        return cell ?? UITableViewCell();
    }
}

extension AddViewController : AddIngredientsHeaderCellDelegate{
    func addIngredientsBtnClicked() {
        self.numberOfRowsForAddIngredients += 1
        self.addIngredientsTableView.reloadData()
    }
    
    
}
