//
//  AddViewController.swift
//  FamilyFinanceTest
//
//  Created by ÇağkanTaştekin on 2019. 06. 25..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit
import MaterialTextField
import Alamofire
class AddViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var addIngredientsTableView: UITableView!
    @IBOutlet weak var addStepsTableView: UITableView!
    @IBOutlet weak var receipeNameTF: MFTextField!
    
    
    
    
    //MARK:- STORED PROPERTIES
    var numberOfRowsForAddIngredients:Int = 1
    var numberOfRowsForAddSteps:Int = 1
    
    var choosenImage:UIImage?
    var ingredientCells = [AddIngredientsTableViewCell]()
    var stepsCells = [AddStepsTableViewCell]()
    var receipeModel:PageData?
    
    
    
    //MARK: - LIFECYCLE CALLS
    override func viewDidLoad() {
        super.viewDidLoad()
        addIngredientsTableView.dataSource = self
        addIngredientsTableView.delegate = self
        addStepsTableView.dataSource = self
        addStepsTableView.delegate = self
        configureNavigationBar()
        self.addStepsTableView.register(AddIngredientsHeaderCell.self, forCellReuseIdentifier: "AddIngredientsHeaderCell")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
    }
    
    //MARK: - INSTANCE METHODS
    
    func configureNavigationBar(){
        //configure navigation bar
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black,  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.visibleViewController?.navigationItem.title = "Add Receipe"
        
        let rightBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveReceipe))
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    
    
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
    
    
    func prepareReceipeRequestModel()->PageData{
        var ingredients = [Ingredient]()
        var steps = [String]()
        for cell in self.ingredientCells{
            ingredients.append(Ingredient(name: cell.nameTF.text, quantity: cell.quantityTF.text, type: cell.typeTF.text))
        }
        
        for cell in self.stepsCells {
            steps.append(cell.stepTextField?.text ?? "")
        }
        return PageData(name: receipeNameTF.text, imgUrl: "", ingredients: ingredients ?? [], steps: steps ?? [])
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
        let receipeRequestModel:PageData =  prepareReceipeRequestModel()
        //        debugPrint(receipeRequestModel)
        //        debugPrint("Receipe Saved")
        if Utile.isInternetAvailable(){
            postReceipeAPICall(receipeRequestModel:receipeRequestModel)
        }else{
            // Declare Alert message
            let dialogMessage = UIAlertController(title: Alerts.KALERT, message: "Please Check Your Internet Connection", preferredStyle: .alert)
            // Create OK button with action handler
            let ok = UIAlertAction(title: Alerts.KAlertRetry, style: .default, handler: { (action) -> Void in
                self.postReceipeAPICall(receipeRequestModel:receipeRequestModel)
            })
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                dialogMessage.dismiss(animated: true, completion: nil)
            }
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            // Present dialog message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    
    func postReceipeAPICall(receipeRequestModel:PageData){
        var params = [String:Any]();
        params["name"] = receipeRequestModel.name ?? ""
        params["imgUrl"] = ""
        var ingredients = [[String:String]()]
        for ing in receipeRequestModel.ingredients {
            ingredients.append(["name":ing.name ?? "","quantity":ing.quantity ?? "","type":ing.type ?? ""])
        }
        params["ingredients"] = ingredients
        params["steps"] = receipeRequestModel.steps
        debugPrint(params)
        let url = URL.init(string: "http://92.177.216.191:7072/uploadRecipe")!
        Utile.showActivityIndicator()
        Alamofire.request(url, method: .post , parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                print(response)
            if response.result.isSuccess {
                self.showAlert(preferredButtonTitle: "OK", alertTitle: "Alert", message: "Receipe Posted Successfully!", onPreferredButtonClick: {
                    self.navigationController?.popToRootViewController(animated: true)
                })
            }else{
                self.showAlert(preferredButtonTitle: "OK", message: "Error While Posting Data To Server!", onPreferredButtonClick: {
                    
                })
            }
            Utile.hideActivityIndicator()
            }
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
            self.ingredientCells.append(cell!)
            return cell ?? UITableViewCell();
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddStepsTableViewCell") as? AddStepsTableViewCell
            self.stepsCells.append(cell!)
            cell?.stepTextField.placeholder = "Step \(indexPath.row+1)"
            return cell ?? UITableViewCell();
        }
    }
}

//MARK: - DELEGATE FOR ADD INGREADIENTS CELL
extension AddViewController : AddIngredientsHeaderCellDelegate{
    func addIngredientsBtnClicked() {
        self.numberOfRowsForAddIngredients += 1
        self.ingredientCells.removeAll()
        self.addIngredientsTableView.reloadData()
    }
}

//MARK: - DELEGATE FOR ADD STEPS CELL
extension AddViewController : AddStepsHeaderCellDelegate {
    func addStepsBtnClicked() {
        self.numberOfRowsForAddSteps += 1
        self.stepsCells.removeAll()
        self.addStepsTableView.reloadData()
    }
}

