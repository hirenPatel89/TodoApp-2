//
//  testAddTaskDetails.swift
//  TodoApp
//
//  Created by Shreeji on 15/06/19.
//  Copyright © 2019 Shreeji. All rights reserved.
//

import UIKit
import Firebase
import XCTest


@testable import TodoApp

class TestAddTaskDetails: XCTestCase{
    
var firRefDB: DatabaseReference!
    

    
    func checkData()  {
    
        print("Data")
    }
    
    func testViewDidload() {
        let vc = HomeView()
        
        vc.viewDidLoad()
        
    }
}
