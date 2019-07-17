//
//  Extensions.swift
//  TodoApp
//
//  Created by Shreeji on 12/06/19.
//  Copyright © 2019 Shreeji. All rights reserved.
//

import Foundation
import UIKit

/* Inside this file we write the all swift extensions of this App */

//For Show Alert  From Any ViewController
extension UIViewController {
    
    /**
     This method will Display the Alert from Any viewController
     
     This method accepts a String value representing the alertTitle and alert Message.
     
     
     ## To use it, simply call ##
     
     popupAlert(title: Hello, message: How Are You)
     
     - Parameter title: Title for your Alert
     - Parameter message: Message that you want to show in alert

     */
    
    
    func popupAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         alert.addAction(okAction)
         self.present(alert, animated: true, completion: nil)
        
    }
    
    
}


// ** For Set & manage UIButton Corner Radius from StoryBoard **
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    //set border 
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
