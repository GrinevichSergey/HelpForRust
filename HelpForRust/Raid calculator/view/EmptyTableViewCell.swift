//
//  EmptyTableViewCell.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 03/01/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("Choose what you want to destroy", comment: "")
        label.textColor = UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)
        label.font = UIFont(name: "Roboto-Regular", size: 18)
        return label
    }()
    
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        backgroundColor = UIColor(red: 68/255, green: 67/255, blue: 63/255, alpha: 1.0)
        
        addSubview(emptyLabel)
        emptyLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        //проверка подключения интернета
       // if TestConnectionNetwork.isConnectedNetwork() {
        emptyLabel.text = NSLocalizedString("Choose what you want to destroy", comment: "")
//        } else {
//             emptyLabel.text = NSLocalizedString("Internet Connection not Available!", comment: "")
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
