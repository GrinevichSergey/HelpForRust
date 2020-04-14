//
//  IAPService.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 03/04/2020.
//  Copyright © 2020 Grinevich Sergey. All rights reserved.
//

import Foundation
import StoreKit


protocol LabelChangeText: class {
    func chancheTextLabel()
}



class IAPService: NSObject {
    
    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    var paymentQueue = SKPaymentQueue.default()
    
    weak var delegate: LabelChangeText?
    
    func getProduct() {
        let prod: Set = [IAPProduct.nonConsumable.rawValue]
        let request = SKProductsRequest(productIdentifiers: prod)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
        
    }
    
    func purchase(prod: IAPProduct)  {
        guard let productToPurchase = products.filter({$0.productIdentifier == prod.rawValue}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases()  {
        print("restore")
        paymentQueue.restoreCompletedTransactions()
    }
}

extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
    
    
}


extension IAPService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased, .restored:
                UserDefaults.standard.set(true, forKey: "purchaseRustHelpRemoveAds")
                delegate?.chancheTextLabel()
                queue.finishTransaction(transaction)
//                break
            default:
                delegate?.chancheTextLabel()
                queue.finishTransaction(transaction)
            }
        }
    }
    
    
}


extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred:     return "deferred"
        case .failed:       return "failed"
        case .purchased:    return "purchased"
        case .purchasing:   return "purchasing"
        case .restored:     return "restored"
        default:            return "default"
        }
    }
}
