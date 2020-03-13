//
//  PurchaseVC.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 11/01/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseVC: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver  {
    
    var purchaseRustHelpRemoveAds = UserDefaults.standard.bool(forKey: "purchaseRustHelpRemoveAds")
    
    
    var p = SKProduct()
    var list = [SKProduct]()
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let myProduct = response.products
        print(myProduct)
        for product in myProduct {
            list.append(product)
        }
        print(list)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            
            switch trans.transactionState {
            case .purchased:
                let prodID = p.productIdentifier
                switch prodID {
                case "DorofeevEvgenyApplication.RustHelp.RemoveAds":
                    print("purchased")
                    purchaseRustHelpRemoveAds = true
                    UserDefaults.standard.set(purchaseRustHelpRemoveAds, forKey: "purchaseRustHelpRemoveAds")
                    
                default:
                    print("IAP not found")
                }
                queue.finishTransaction(trans)
                break
            case .restored:
                print("restored")
                purchaseRustHelpRemoveAds = true
                UserDefaults.standard.set(purchaseRustHelpRemoveAds, forKey: "purchaseRustHelpRemoveAds")
                queue.finishTransaction(trans)
                break
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break
            default:
                print("Default")
                break
            }
            
        }
    }
    
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Icon-App-60x60")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var label: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.textColor = .white
        text.textAlignment = .center
        text.font = UIFont(name: "Roboto-Regular", size: 16)
//        text.text = "Advertisement is an important part of the application development. You can disable ads for support, development and comfortable use of the application. Hope for your understanding."
        return text
    }()
    
    
    lazy var removeAds: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor =  UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)
        let removeAdsText = NSLocalizedString("Remove Ads", comment: "")
        btn.setTitle(removeAdsText, for: .normal)
        btn.titleLabel?.textColor = .black
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        btn.addTarget(self, action: #selector(tapRemoveAds), for: .touchUpInside)
        UIView.animate(withDuration: 0.6, animations: {
            btn.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.6, animations: {
                    btn.transform = CGAffineTransform.identity
                })
        })
       // btn.showsTouchWhenHighlighted = true
        return btn
    }()
    
    lazy var restorePurchases: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor =  UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)
        let restorePurchasesText = NSLocalizedString("Restore Purchases", comment: "")
        btn.setTitle(restorePurchasesText, for: .normal)
        btn.titleLabel?.textColor = .black
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        UIView.animate(withDuration: 0.6, animations: {
                   btn.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
                   }, completion: { (finish) in
                       UIView.animate(withDuration: 0.6, animations: {
                           btn.transform = CGAffineTransform.identity
                       })
               })
       // btn.showsTouchWhenHighlighted = true
        btn.addTarget(self, action: #selector(tapRestorePurchases), for: .touchUpInside)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
        
        if(SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID: NSSet = NSSet(objects: "DorofeevEvgenyApplication.RustHelp.RemoveAds")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAPS")
        }
        
        if purchaseRustHelpRemoveAds {
            label.text = NSLocalizedString("Thanks for your support.", comment: "thanks for your support.")//"Спасибо за вашу поддержку"
        } else {
            label.text = NSLocalizedString("Advertisement is an important part of the application development. You can disable ads for support, development and comfortable use of the application. Hope for your understanding.", comment: "advertisement is an important part of the application development. You can disable ads for support, development and comfortable use of the application. Hope for your understanding.")//"Реклама является важной частью развития приложения. Для поддержки, развития и комфортного использования приложения Вы можете отключить рекламу. Надеемся на Ваше понимание."
        }
        
    }
    
    
    @objc func tapRestorePurchases() {
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    
    @objc func tapRemoveAds() {
        
        for product in self.list {
            if (product.productIdentifier == "DorofeevEvgenyApplication.RustHelp.RemoveAds") {
                self.p = product
                let pay = SKPayment(product: product)
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(pay as SKPayment)
            }
        }
        
    }
    
    
    
}


//MARK: setupComponents
extension PurchaseVC {
    
    
    func setupComponents() {
        
        navigationItem.title = "Purchases"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 134/255, green: 149/255, blue: 106/255, alpha: 1.0)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 72/255, green: 71/255, blue: 66/255, alpha: 1.0)
        
        view.backgroundColor = UIColor(red: 93/255, green: 95/255, blue: 92/255, alpha: 1.0)
        
        let container: UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16).isActive = true
        container.heightAnchor.constraint(equalToConstant: 150).isActive = true
        container.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        container.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        container.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
        
        
        container.addSubview(label)
        label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5).isActive = true
        label.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        label.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        view.addSubview(removeAds)
        
        removeAds.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 50).isActive = true
        removeAds.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        removeAds.heightAnchor.constraint(equalToConstant: 40).isActive = true
        removeAds.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(restorePurchases)
        restorePurchases.topAnchor.constraint(equalTo: removeAds.bottomAnchor, constant: 10).isActive = true
        restorePurchases.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        restorePurchases.heightAnchor.constraint(equalToConstant: 40).isActive = true
        restorePurchases.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        
    }
    
    
    
}
