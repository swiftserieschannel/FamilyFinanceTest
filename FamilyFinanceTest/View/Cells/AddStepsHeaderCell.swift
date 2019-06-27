//
//  AddStepsHeaderCell.swift
//  FamilyFinanceTest
//
//  Created by chander bhushan on 27/06/19.
//  Copyright © 2019 ÇağkanTaştekin. All rights reserved.
//

import UIKit


protocol AddStepsHeaderCellDelegate{
    func addStepsBtnClicked()
}

class AddStepsHeaderCell: UITableViewCell {
    
    var delegate:AddStepsHeaderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func clickedBtnAddSteps(_ sender: Any) {
        delegate?.addStepsBtnClicked()
    }
    
}
