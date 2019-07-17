//
//  Constant.swift
//  TodoApp
//
//  Created by Shreeji on 12/06/19.
//  Copyright © 2019 Shreeji. All rights reserved.
//

import UIKit


/*  We use this File to define the Constant variables structs,etc.. for this App */



//** with Appcolor struct we can manage the colors globally in whole App .**//

/**
 with Appcolor struct we can manage the colors globally in whole App
 
 This method accepts a String value representing the alertTitle and alert Message.
 you can set UIColor and Alpha values  in navBarColor
 
 To use it, simply call
   view.backgroundColor = Appcolor.navBarColor
 
 
 */
let ALERTTITLE = "TODO"

struct Appcolor{
    
    //navigation bar color that apply on whole app screens navigation bar
    
    static let navBarColor =  UIColor(red: 58/255.0, green: 43/255.0, blue: 134/255.0, alpha: 1.0)
    
}


