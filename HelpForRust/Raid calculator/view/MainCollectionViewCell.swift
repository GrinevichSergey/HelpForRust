//
//  MainSectionViewCell.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 21/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase

class MainCollectionViewCell: UICollectionViewCell {
    
    override func prepareForReuse() {
         self.mainImageView.image = nil
     }

//    var itemsMain: ItemsWeapons? {
//        didSet {
//            observeItemsMain()
//        }
//    }
    
//     func  observeItemsMain() {
//
//        if let id = itemsMain?.items_id {
//
//              let ref = Database.database().reference().child("RaidCalculator").child("Items").child(String(id))
//              ref.observeSingleEvent(of:of: .value, with: { (snapshot) in
//
//                  if let dictionary = snapshot.value as? [String: AnyObject] {
//
//                      if let imageUrl = dictionary["imageUrl"] as? String {
//
//                          self.mainImageView.loadImageCacheWidthUrlString(urlString: imageUrl)
//
//                      }
//
//
//                  }
//
//              }, withCancel: nil)
//
//
//          }
//
//      }
    

    lazy var mainTextLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
        label.textColor = UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)
        label.font = UIFont(name: "Roboto-Bold", size: 14)
        return label
    }()
    
    lazy var mainImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
//        image.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupComponent()
        
    }
    
    func setupComponent() {
        
        addSubview(mainImageView)
        mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6).isActive = true
        mainImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        mainImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
       // mainImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        addSubview(mainTextLabel)
        mainTextLabel.leftAnchor.constraint(equalTo: mainImageView.rightAnchor, constant: 3).isActive = true
       // mainTextLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        mainTextLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mainTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
     //   mainTextLabel.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
