//
//  UIViewController+Extension.swift
//  FamilyFinanceTest
//
//  Created by chander bhushan on 29/06/19.
//  Copyright © 2019 ÇağkanTaştekin. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    func presentAlert(title : String ,message : String ,buttonTitle : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlert(preferredButtonTitle: String, alertTitle: String? = nil, message: String, onPreferredButtonClick: @escaping ()-> ()) {
        
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        let preferredAction = UIAlertAction(title: preferredButtonTitle, style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            onPreferredButtonClick()
        }
        alert.view.tintColor = UIColor.blue.withAlphaComponent(0.3)
        alert.addAction(preferredAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
