//
//  headerBannerReusableView.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 04/02/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//

import UIKit

class headerBannerReusableView: UICollectionReusableView {
    
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        return label
    }()
        
//    func labelInternetConnection() {
//        //  backgroundColor = .red
//
//        //проверка подключения интернета
//        if TestConnectionNetwork.isConnectedNetwork() == false
//        {
//            addSubview(label)
//            label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//            label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//            label.text = NSLocalizedString("Internet Connection not Available!", comment: "")
//        } else {
//            label.text = nil
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    //    labelInternetConnection()
         
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
