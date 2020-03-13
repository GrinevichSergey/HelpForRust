//
//  AmmoGroup.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 03/02/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//

import UIKit

class AmmoGroup: NSObject {
    
    var id: String?
    var Value_1: String?
    var image_: String?
    var name: String?
 
    
    init(dictionary: [String: Any]) {
        super.init()
        id = dictionary["uid"] as? String
        Value_1 = dictionary["value_1"] as? String
        image_ = dictionary["imageURL"] as? String
        name = dictionary["name"] as? String
    }
    
}
