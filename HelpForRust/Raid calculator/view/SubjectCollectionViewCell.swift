//
//  raidSubjectCollectionViewCell.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 16/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage
import Alamofire

class SubjectCollectionViewCell: UICollectionViewCell {
    
    var subjectArray : Subject? {
        didSet {
            observeSubjectRaidCalculator() 
        }
    }
    
    override func prepareForReuse() {
        self.subjectImageView.image = nil
    }
    
//    var ImageCache = [String:UIImage]()
    
    
    let subjectImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            //выделить цветом выбранную ячейку
            self.contentView.backgroundColor = isSelected ? UIColor(red: 218/255, green: 84/255, blue: 63/255, alpha: 1.0) : UIColor.clear
            //прозрачность
            self.subjectImageView.alpha = isSelected ? 0.75 : 1.0
        }
    }

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    
    
    
    private func observeSubjectRaidCalculator() {
        
        if let imageUrl = subjectArray?.imageUrl,
            
//            let ref = Database.database().reference().child("RaidCalculator").child("Subject").child(String(id))
//
//            ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                if let dictionary = snapshot.value as? [String: AnyObject],
//                    let imageUrl = dictionary["imageUrl"]  as? String,
                    let url = URL(string: imageUrl)
                    {
                        self.subjectImageView.af.cancelImageRequest()
                        self.subjectImageView.af.setImage(withURL: url, cacheKey: imageUrl)
//
//                        let dishName = imageUrl
//
//                        if let dishImage = self.ImageCache[dishName] {
//                            let dishImageView: UIImageView = self.subjectImageView
//                            dishImageView.image = dishImage
//
//                        } else {
//                            AF.request(imageUrl)
//                                .responseImage { response in
//                                    debugPrint(response)
//                                    debugPrint(response.result)
//
//                                    if let image = response.value {
//                                     //   print("image downloaded: \(image)")
//
//                                        // Store the commit date in to our cache
//                                        self.ImageCache[dishName] = image
//
//                                        // Update the cell
//                                        DispatchQueue.main.async {
//
//                                            let dishImageView:UIImageView = self.subjectImageView
//                                            dishImageView.image = image
//
//
//                                        }
//
//                                    }
//                            }
//                        }
                        
                        
                        //   self.subjectImageView.loadImageCacheWidthUrlString(urlString: imageUrl)
//                    }
                    
                }
                
                
//            }, withCancel: nil)
            
//        }
        
    }
    
    func addView() {
        
        addSubview(subjectImageView)
        
        
        subjectImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subjectImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        subjectImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        subjectImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
