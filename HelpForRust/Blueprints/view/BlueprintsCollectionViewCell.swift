//
//  BlueprintsCollectionViewCell.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 03/02/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//


import UIKit
import Firebase
import Alamofire
import AlamofireImage

class BlueprintsCollectionViewCell: UICollectionViewCell{
    
    var furnaceInfoArray : AmmoGroup? {
        didSet {
            setupImageFurnace()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bg.image = nil
    }
    

    public var valueLevelPublic = String()
    
    public var id = String()
    public var value = String()
    var ImageCache = [String: UIImage]()
    
    func setupImageFurnace() {
        
        if let imageUrl = furnaceInfoArray?.image_,
            
            let url = URL(string: imageUrl), let id = furnaceInfoArray?.id, let value = furnaceInfoArray?.Value_1  {
            
            self.bg.af.cancelImageRequest()
            self.bg.af.setImage(withURL: url, cacheKey: imageUrl)
            self.id = id
            self.value = value
            
//            let ref = Database.database().reference().child("Blueprints").child("Level").child(valueLevelPublic).child(id)
//            ref.observeSingleEvent(of:of: .value) { (snapshot) in
//
//
//
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//
//                    if let imageURL = dictionary["imageURL"] as? String{
//
//                          self.bg.loadImageCacheWidthUrlString(urlString: imageURL)
//                    }
//
//
//                    if let id = dictionary["uid"] as? String{
//                        self.id = id
//                    }
//
//
//                    if let value = dictionary["value_1"] as? String{
//                        self.value = value
//                    }
//
//                }
//            }
        }
    }
    
    
    
    
    public let bg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.image = UIImage(named: "Ammo1" )
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        // iv.tintColor = UIColor.orange
        
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bg)
        
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    override var isSelected: Bool {
        didSet {
            //  выделить цветом выбранную ячейку
           
                self.contentView.backgroundColor = isSelected ? UIColor(red: 116/255, green: 132/255, blue: 87/255, alpha: 1) : UIColor(red: 56/255, green: 54/255, blue: 48/255, alpha: 1.0)
                //прозрачность
                self.bg.alpha =  isSelected ? 0.75 : 1.0
        }
    }
    
 
      
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
}


