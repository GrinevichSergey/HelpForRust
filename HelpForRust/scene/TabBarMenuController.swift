//
//  TabBarMenuController.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 14/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

class TabBarMenuController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let furnaceInfo = FurnaceInfoVC()
        let raidCalculator = RaidCalculatorVC()
        let purchase = PurchaseVC()
        let blueprints = BlueprintsVC()
       
        //MARK: furnaceInfo
        
        furnaceInfo.tabBarItem = UITabBarItem(title: "Furnace Info", image: UIImage(named: "Large_Furnace_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), tag: 0)
        
        //MARK: raid calc
        
        raidCalculator.tabBarItem = UITabBarItem(title: "Raid calculator", image: UIImage(named: "Rocket_image_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), tag: 0)
        
        //MARK: purchase
        
        purchase.tabBarItem = UITabBarItem(title: "Purchase", image: UIImage(named: "Vending_Machine_icon-2")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), tag: 0)
        
        //MARK: Blueprints
        
        blueprints.tabBarItem = UITabBarItem(title: "Blue prints", image: UIImage(named: "blueprints")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), tag: 0)
        
        
        
        
        let viewControllerList = [UINavigationController.init(rootViewController: raidCalculator), UINavigationController.init(rootViewController: furnaceInfo),UINavigationController.init(rootViewController: blueprints), UINavigationController.init(rootViewController: purchase)]
        
        viewControllers = viewControllerList
    }
    

  

}
