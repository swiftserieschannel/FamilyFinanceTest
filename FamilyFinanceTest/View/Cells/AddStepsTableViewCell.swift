//
//  addStepsTableViewCell.swift
//  FamilyFinanceTest
//
//  Created by chander bhushan on 27/06/19.
//  Copyright © 2019 ÇağkanTaştekin. All rights reserved.
//

import UIKit
import MaterialTextField


class AddStepsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stepTextField: MFTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
