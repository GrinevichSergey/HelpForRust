//
//  Subject.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 20/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//


import UIKit
import Firebase


class Subject: NSObject {
    
    var id: Int?
    var imageUrl: String?
    var type: String?
    
    
    init(dictionary: [String: Any]) {
        super.init()

        id = dictionary["id"] as? Int
        imageUrl = dictionary["imageUrl"] as? String
        type = dictionary["type"] as? String
    }

    
}

class Weapons: NSObject {
    
    var id: Int?
    var imageUrl: String?
    var name: String?

    init(dictionary: [String: Any]) {
        super.init()
        self.id = dictionary["id"] as? Int
        self.imageUrl = dictionary["imageUrl"] as? String
        self.name = dictionary["name"] as? String
    }
       
}

class WeaponsSubject: NSObject {
    
    
    var id: Int?
    var weapons_id : Int?
    var subject_id: Int?
    var value : Int?
    
    init(dictionary: [String: Any]) {
    
        id = dictionary["id"] as? Int
        weapons_id = dictionary["weapons_id"] as? Int
        subject_id = dictionary["subject_id"] as? Int
        value = dictionary["value"] as? Int
        
//        let subjectDic = dictionary["Subject"] as! [String: Any]
//        subject.id = subjectDic["id"] as? String
//        subject.imageUrl = subjectDic["imageUrl"] as? String
//        subject.type = subjectDic["type"] as? String
        
    
    }
}


class WeaponSubjectDTO {
    
    var weapon : Weapons
    var subject : WeaponsSubject
    var items: [ItemsWeaponsDTO]
    var compound: [ItemsCompoundDTO]
    
    
    init(weapon: Weapons, subject: WeaponsSubject, items: [ItemsWeaponsDTO] , compound: [ItemsCompoundDTO]) {
        self.weapon = weapon
        self.subject = subject
        self.items = items
        self.compound = compound
    }
}

