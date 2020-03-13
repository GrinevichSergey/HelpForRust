//
//  Weapon.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 24/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//с

import UIKit


class Weapon: NSObject {
    
    var id: String?
    var imageUrl: String?
    var value: String?
    var subjectId: Int?
    var main = WeaponStruct()
    
    var compound = WeaponStruct()
    
    init(dictionary: [String: Any]) {
        super.init()
        
        id = dictionary["id"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        value = dictionary["value"] as? String
        subjectId = dictionary["subject_id"] as? Int

    }
    
    init(dictionaryMain: [String: Any]) {
        super.init()
      
        main.id = dictionaryMain["id"] as? String
        main.value = dictionaryMain["value"] as? String
        main.image = dictionaryMain["imageUrl"] as? String
        
    }
    
    init(dictionaryCompound: [String: Any]) {
        super.init()
        
        compound.value = dictionaryCompound["value"] as? String
        compound.image = dictionaryCompound["imageUrl"] as? String
           
       }
       
}

struct WeaponStruct {
    
    var id: String?
    var value: String?
    var image: String?
    
}

//
//class WeaponItems: NSObject {
//
//     var value: String?
//     var image: String?
//
//    init(dictionary: [String: AnyObject]) {
//        super.init()
//        value = dictionary["value"] as? String
//        image = dictionary["imageUrl"] as? String
//
//    }
//
// }



//init(dictionaryCompound: [String: AnyObject]) {
//      super.init()
//
//      let compoundWeapor = dictionaryCompound["compoundWeapon"] as? [String: AnyObject]
//
//      compound.value = compoundWeapor?["value"] as? String
//      compound.image = compoundWeapor?["imageUrl"] as? String
//
//     }




