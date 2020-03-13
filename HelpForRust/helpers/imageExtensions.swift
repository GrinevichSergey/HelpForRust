//
//  imageExtensions.swift
//  HelpForRust
//
//  Created by Сергей Гриневич on 14/12/2019.
//  Copyright © 2019 Grinevich Sergey. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageCacheWidthUrlString(urlString: String)  {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject ) as? UIImage {
            self.image = cachedImage
            return
        }
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, response, error ) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                if let dowloadedImage = UIImage(data: data!) {
                    imageCache.setObject(dowloadedImage, forKey: urlString as AnyObject)
                    self?.image = dowloadedImage
                }
             
            }
            
            } .resume()
    }
    
}
