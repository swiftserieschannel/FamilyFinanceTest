//
//  ListDataModal.swift
//  FamilyFinanceTest
//
//  Created by ÇağkanTaştekin on 2019. 06. 25..
//  Copyright © 2019. ÇağkanTaştekin. All rights reserved.
//

import Foundation

struct PageData : Codable{
    let name : String?
    let imgUrl : String?
    let ingredients : [Ingredient]
    let steps : [String]
}

struct Ingredient : Codable{
    let name : String?
    let quantity : String?
    let type : String?
}
