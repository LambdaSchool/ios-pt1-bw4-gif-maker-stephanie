//
//  UIViewController-Extension.swift
//  Gif Maker
//
//  Created by Stephanie Bowles on 1/13/20.
//  Copyright © 2020 Stephanie Bowles. All rights reserved.
//

import UIKit

extension UIViewController {

    func postAlert(_ title: String, message: String) {
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            let alert = UIAlertController(title: title, message: message,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            let popOver = alert.popoverPresentationController
            popOver?.sourceView  = self.view
            popOver?.sourceRect = self.view.bounds
            popOver?.permittedArrowDirections = UIPopoverArrowDirection.any
            
            
            self.present(alert, animated: true, completion: nil)
            
        })
        
    }
}
