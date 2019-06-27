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
        //configure navigation bar
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.visibleViewController?.navigationItem.title = "Add Receipe"
        
        let rightBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveReceipe))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        self.addStepsTableView.register(AddIngredientsHeaderCell.self, forCellReuseIdentifier: "AddIngredientsHeaderCell")
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
    
    @objc func saveReceipe(){
        debugPrint("Receipe Saved")
    }
    
}

//MARK: - EXTENSION FOR INGREDIENTS TABLE VIEW DATA SOURCE
extension AddViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.addIngredientsTableView {
            return  numberOfRowsForAddIngredients
        }else{
            return numberOfRowsForAddSteps
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        if tableView == addIngredientsTableView{
            let header = tableView.dequeueReusableCell(withIdentifier: "AddIngredientsHeaderCell")! as! AddIngredientsHeaderCell
            header.delegate = self
            return header
        }else{
            let header = tableView.dequeueReusableCell(withIdentifier: "AddStepsHeaderCell")! as! AddStepsHeaderCell
            header.delegate = self
            return header
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addIngredientsTableView{
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddIngredientsTableViewCell") as? AddIngredientsTableViewCell
        return cell ?? UITableViewCell();
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddStepsTableViewCell") as? AddStepsTableViewCell
            return cell ?? UITableViewCell();
        }
    }
}

extension AddViewController : AddIngredientsHeaderCellDelegate{
    func addIngredientsBtnClicked() {
            self.numberOfRowsForAddIngredients += 1
            self.addIngredientsTableView.reloadData()
    }
}

extension AddViewController : AddStepsHeaderCellDelegate {
    func addStepsBtnClicked() {
        self.numberOfRowsForAddSteps += 1
        self.addStepsTableView.reloadData()
    }
}
