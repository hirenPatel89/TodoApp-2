//
//  HomeView.swift
//  TodoApp
//
//  Created by Shreeji on 12/06/19.
//  Copyright © 2019 Shreeji. All rights reserved.
//

import UIKit 
class HomeView: UIViewController {
  

    @IBOutlet weak var btnAddTask: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
   
    //MARK:- Button Click Events
    
    @IBAction func btnCreateTaskClicked(_ sender: Any) {
        //Redirect user to  user to the AddTaskDetails Screen for add new task
        let AddTaskDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskDetails")as! AddTaskDetails
        self.navigationController?.pushViewController(AddTaskDetailsView, animated: true)
        
       
    }
    @IBAction func btnViewTaskClicked(_ sender: Any) {
        //Redirect user to  user to the ListTask Screen for View the list of tasks
        let viewtaskScreen = self.storyboard?.instantiateViewController(withIdentifier: "ListTaskViewController")as! ListTaskViewController
        
        self.navigationController?.pushViewController(viewtaskScreen, animated: true)
    }
    @IBAction func btnPlusClick(_ sender: Any) {
        //Redirect user to  user to the AddTaskDetails Screen for add new task
        let AddTaskDetailsView = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskDetails")as! AddTaskDetails
        self.navigationController?.pushViewController(AddTaskDetailsView, animated: true)
        
    }
}
