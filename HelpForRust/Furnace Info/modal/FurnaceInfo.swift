//
//  FurnaceInfo.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 14/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

class Furnace: NSObject {
    
    var id: String?
    var imageUrl: String?
    var type: String?
    
    init(dictionary: [String: Any]) {
        super.init()
        id = dictionary["id"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        type = dictionary["type"] as? String
    }
    
}
