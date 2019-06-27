//
//  IngredientsTableViewCell.swift
//  FamilyFinanceTest
//
//  Created by chander bhushan on 27/06/19.
//  Copyright © 2019 ÇağkanTaştekin. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {

    //MARK: - OUTLETS
    @IBOutlet weak var ingredientsTextLabel: UILabel!
    @IBOutlet weak var ingredientsTypeLabel: UILabel!
    @IBOutlet weak var ingredientsQuantity: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    //MARK: - LIFECYCLE CALLS
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
