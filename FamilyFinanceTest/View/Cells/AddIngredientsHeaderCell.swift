//
//  AddIngredientsHeaderCell.swift
//  FamilyFinanceTest
//
//  Created by chander bhushan on 27/06/19.
//  Copyright © 2019 ÇağkanTaştekin. All rights reserved.
//

import UIKit

protocol AddIngredientsHeaderCellDelegate{
    func addIngredientsBtnClicked()
}

class AddIngredientsHeaderCell: UITableViewCell {

    
    @IBOutlet weak var headerLabel: UILabel!
    var delegate:AddIngredientsHeaderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clickedBtnAddIngredients(_ sender: Any) {
        delegate?.addIngredientsBtnClicked()
    }
}
