//
//  DetailViewController.swift
//  FamilyFinanceTest
//
//  Created by ÇağkanTaştekin on 2019. 06. 25..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit
import SDWebImage
class DetailViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!
    
    //MARK:- STORED PROPERTIES
    var receipe:PageData?
    var numberOfRowAtSections:[Int]?
    //MARK:- LIFECYCLE CALLS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientsTableView.tableFooterView = UIView()
        foodImage.layer.cornerRadius = 5
        self.ingredientsTableView.dataSource = self
        self.ingredientsTableView.rowHeight = UITableView.automaticDimension
        numberOfRowAtSections = [receipe?.ingredients.count,receipe?.steps.count] as? [Int]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        foodName.text = receipe?.name
        DispatchQueue.main.async {
            self.foodImage.sd_setShowActivityIndicatorView(true)
            self.foodImage.sd_setIndicatorStyle(.gray)
            self.foodImage.sd_setImage(with: URL(string: self.receipe?.imgUrl ?? ""), placeholderImage: UIImage(), options: .handleCookies, completed: nil)
        }
    }
    
}

//MARK:- EXTENSION FOR INGREDIENTS TABLE VIEW DATASOURCE
extension DetailViewController : UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Ingredients"
        }else{
            return "Steps"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if section < numberOfRowAtSections?.count ?? 0 {
            rows = numberOfRowAtSections?[section] ?? 0
        }
        return rows
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsTableViewCell") as? IngredientsTableViewCell
        if indexPath.section == 0 {
            cell?.ingredientsTypeLabel.isHidden = false
            cell?.ingredientsQuantity.isHidden = false
            cell?.ingredientsTextLabel.text = receipe?.ingredients[indexPath.row].name
            cell?.ingredientsTypeLabel.text = receipe?.ingredients[indexPath.row].type
            cell?.ingredientsQuantity.text = receipe?.ingredients[indexPath.row].quantity
        }else{
            cell?.ingredientsTextLabel.text = receipe?.steps[indexPath.row]
            cell?.ingredientsTypeLabel.isHidden = true
            cell?.ingredientsQuantity.isHidden = true
            cell?.iconImageView.image = UIImage(named: "arrow")
        }
        return cell ?? UITableViewCell()
    }
    
}

extension DetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}
