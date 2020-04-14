//
//  InsideRaidCollectionViewCell.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 20/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase

class CompoundCollectionViewCell: UICollectionViewCell {
    //
    //    var itemsCompound: ItemsCompound? {
    //        didSet {
    //            observeItemsCompound()
    //        }
    //    }
    //
    //     func  observeItemsCompound() {
    //
    //        if let id = itemsCompound?.items_compound_id {
    //
    //              let ref = Database.database().reference().child("RaidCalculator").child("Items").child(String(id))
    //              ref.observeSingleEvent(of:of: .value, with: { (snapshot) in
    //
    //                  if let dictionary = snapshot.value as? [String: AnyObject] {
    //
    //                      if let imageUrl = dictionary["imageUrl"] as? String {
    //
    //                          self.compoundImageView.loadImageCacheWidthUrlString(urlString: imageUrl)
    //
    //                      }
    //
    //                  }
    //
    //              }, withCancel: nil)
    //
    //
    //          }
    //
    //      }
    
 
    override func prepareForReuse() {
        super.prepareForReuse()
        self.compoundImageView.image = nil
        self.compoundImageView.af.cancelImageRequest()
    }
    
    lazy var labelCompound : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
        label.textColor = UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)
        label.font = UIFont(name: "Roboto-Bold", size: 14)
        return label
    }()
    
//    lazy var labelCompound1 : UILabel = {
//         let label = UILabel()
//         label.translatesAutoresizingMaskIntoConstraints = false
//         label.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
//         label.textColor = UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)
//         label.font = UIFont(name: "Roboto-Bold", size: 14)
//         return label
//     }()
    
    lazy var compoundImageView : UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupComponent()
    }
    
    func setupComponent() {
      
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing  = 2.0
        stackView.addArrangedSubview(compoundImageView)
        stackView.addArrangedSubview(labelCompound)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 3).isActive = true
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        compoundImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        compoundImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true

        labelCompound.heightAnchor.constraint(equalToConstant: 25).isActive = true
        labelCompound.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
  
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
