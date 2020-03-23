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
    var valueSum: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageUrl)
        hasher.combine(valueSum)
        
        
    }
    
    
    init(imageUrl : String, valueSum: Double) {
        
        self.imageUrl = imageUrl
        self.valueSum = valueSum
        
        
    }
    
    static func == (lhs: Compound, rhs: Compound) -> Bool {
        return lhs.imageUrl == rhs.imageUrl && lhs.valueSum == rhs.valueSum
    }
}

