//
//  Items.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 17/02/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//

import UIKit 

class Items: NSObject {
    
    var id: Int?
    var imageUrl: String?
    var name: String?
    
    init(dictionary: [String: Any]) {
        //        super.init()
        
        id = dictionary["id"] as? Int
        imageUrl = dictionary["imageUrl"] as? String
        name = dictionary["name"] as? String
        
    }
    
}

class ItemsWeapons: NSObject {
    
    var id: Int?
    var weapons_id : Int?
    var items_id: Int?
    var value : Int?
    
    init(dictionary: [String: Any]) {
        
        id = dictionary["id"] as? Int
        weapons_id = dictionary["weapons_id"] as? Int
        items_id = dictionary["items_id"] as? Int
        value = dictionary["value"] as? Int
        
    }
    
}

class ItemsWeaponsDTO {
    
    var items : Items
    var weapons : ItemsWeapons
    
    init(items: Items, weapons: ItemsWeapons ) {
        self.items = items
        self.weapons = weapons
    }
    
    
}

class ItemsCompound: NSObject {
    
    var id: Int?
    var items_id: Int?
    var items_compound_id: Int?
    var value_compound : Int?
    
    
    init(dictionary: [String: Any]) {
        
        id = dictionary["id"] as? Int
        items_id = dictionary["items_id"] as? Int
        items_compound_id = dictionary["items_compound_id"] as? Int
        value_compound = dictionary["value_compound"] as? Int
        
    }
    
}


class ItemsCompoundDTO : Hashable  {
  
    var items: Items
    var compound: ItemsCompound
    
    
    
    init(items: Items, compound: ItemsCompound) {
        self.items = items
        self.compound = compound
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(items)
        hasher.combine(compound)
    }

    
    static func == (lhs: ItemsCompoundDTO, rhs: ItemsCompoundDTO) -> Bool {
        return lhs.items == rhs.items && lhs.compound == rhs.compound
      }
  
}


class ItemsCompoundDTOSum {
    
    var items: Items
    var compound: ItemsCompound
    var sumCompound : Int
    var sumSompoundToCompound: Int
    
    init(items: Items, compound: ItemsCompound, sumCompound: Int,  sumSompoundToCompound: Int) {
        self.items = items
        self.compound = compound
        self.sumCompound = sumCompound
        self.sumSompoundToCompound = sumSompoundToCompound
    }
    
    
}

