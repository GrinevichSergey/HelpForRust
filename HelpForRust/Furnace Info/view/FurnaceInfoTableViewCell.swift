//
//  FurnaceInfoTableViewCell.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 14/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase

class FurnaceInfoTableViewCell: UITableViewCell {
    
    var furnaceInfoArray : Furnace? {
        didSet {
            setupImageFurnace()
        }
    }
    
    override func prepareForReuse() {
         super.prepareForReuse()
         self.furnaceimageView.image = nil
  
     }
    
    let furnaceimageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    
    func setupImageFurnace()  {
        
        if let imageUrl = furnaceInfoArray?.imageUrl,
        
        let url = URL(string: imageUrl) {
        
        self.furnaceimageView.af.cancelImageRequest()
        self.furnaceimageView.af.setImage(withURL: url, cacheKey: imageUrl)
  
        }
        
            
            
        
//        if let id = furnaceInfoArray?.id {
//
//            let ref = Database.database().reference().child("FurnaceInfo").child(id)
//
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//                    if let imageUrl = dictionary["imageUrl"] as? String {
//                        self.furnaceimageView.loadImageCacheWidthUrlString(urlString: imageUrl)
//                    }
//
//                }
//
//            }, withCancel: nil)
//
//
//        }
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
   
        
        contentView.backgroundColor = UIColor(red: 93/255, green: 95/255, blue: 92/255, alpha: 1.0)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(furnaceimageView)
//        furnaceimageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        furnaceimageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        furnaceimageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        furnaceimageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
         furnaceimageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
