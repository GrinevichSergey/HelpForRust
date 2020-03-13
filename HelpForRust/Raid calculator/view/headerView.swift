//
//  headerView.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 21/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    lazy var mainTextLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 20))
        label.textAlignment = .center
       // label.text = "Основные предметы"
        label.textColor = UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)
        label.font = UIFont(name: "Roboto-Regular", size: 13)
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
        
        addSubview(mainTextLabel)
    }
    
    
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}
