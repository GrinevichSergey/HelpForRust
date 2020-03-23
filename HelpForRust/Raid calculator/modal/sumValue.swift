//
//  sumValue.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 20/03/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//

import UIKit

class Compound: Hashable {
    
    
    var imageUrl: String
    var valueSum: Int
    var id_compound: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageUrl)
        hasher.combine(valueSum)
        hasher.combine(id_compound)
        
    }
   

    init(imageUrl : String, valueSum: Int, id_compound: Int) {
        
        self.imageUrl = imageUrl
        self.valueSum = valueSum
        self.id_compound = id_compound
        
    }
    
    static func == (lhs: Compound, rhs: Compound) -> Bool {
           return lhs.imageUrl == rhs.imageUrl && lhs.valueSum == rhs.valueSum && lhs.id_compound == rhs.id_compound
         }
}

