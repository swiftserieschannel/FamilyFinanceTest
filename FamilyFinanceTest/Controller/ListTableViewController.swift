//
//  ListTableViewController.swift
//  FamilyFinanceTest
//
//  Created by ÇağkanTaştekin on 2019. 06. 25..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
class ListTableViewController: UITableViewController {
    
    let url = URL(string: "http://94.177.216.191:7072/getRecipes")
    let decoder = JSONDecoder()
    
    var arr = [PageData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView();
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "addbtn"), style: .done, target: self, action: #selector(goToNewReceipe))
        
            self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        Utile.showActivityIndicator()
        fetchJsonData()
    }
    
    @objc func goToNewReceipe(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arr.count
    }
    
    
    // Fetch Json Data
    // ==============================================================================================
    func fetchJsonData(){
        // http://94.177.216.191:7072/getRecipes
            Alamofire.request(self.url!).responseData { response in
                Utile.hideActivityIndicator();
                guard let data = response.data else { return }
                do {
                    self.arr = try self.decoder.decode([PageData].self, from:data)
                    print(self.arr.count)
                    //print(self.arr[self.arr.count-2])
                   self.tableView.reloadData()
                } catch  {
                    print("having trouble converting it to a dictionary" , error)
                }
            }
    }
   // ==============================================================================================
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300 
    }
    
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        let item = arr[indexPath.row]
        cell.lblRecipeName.text = item.name
        DispatchQueue.main.async {
            cell.imgRecipe.sd_setShowActivityIndicatorView(true)
            cell.imgRecipe.sd_setIndicatorStyle(.gray)
            cell.imgRecipe.sd_setImage(with: URL(string: item.imgUrl ?? ""), placeholderImage: UIImage(), options: .handleCookies, completed: nil)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.receipe = arr[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

