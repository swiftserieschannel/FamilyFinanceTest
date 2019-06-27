//
//  AddIngredientsTableViewCell.swift
//  FamilyFinanceTest
//
//  Created by chander bhushan on 27/06/19.
//  Copyright © 2019 ÇağkanTaştekin. All rights reserved.
//

import UIKit
import MaterialTextField
class AddIngredientsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameTF: MFTextField!
    @IBOutlet weak var typeTF: MFTextField!
    @IBOutlet weak var quantityTF: MFTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
