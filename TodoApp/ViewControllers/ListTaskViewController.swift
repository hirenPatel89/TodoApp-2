//
//  ListTaskViewController.swift
//  TodoApp
//
//  Created by Shreeji on 12/06/19.
//  Copyright © 2019 Shreeji. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD



//class for ListTaskTableview Custom Cell
//we use this class for display the  task Details values inside tableview

class TblCellListTask:UITableViewCell{
    //TblCellListTask controls Outlet
    
    @IBOutlet weak var lblTaskTitle: UILabel!
    @IBOutlet weak var lblTaskDetails: UILabel!
    @IBOutlet weak var lblTaskDate: UILabel!
    @IBOutlet weak var lblTaskTime: UILabel!
    
    
}
//assign the uitableview delegate & datasource to the ListTaskViewController
class ListTaskViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tblListTask: UITableView! //tbl object for reload tableview data
    var arrTaskData:NSMutableArray! //for store the Taskdata that we retrieved from database
    var dicSelectedTask:NSDictionary! //for pass the Selected task details in editTask Screen
    var ref: DatabaseReference!  //Firebase Realtime Database reference for use firebase methods & property
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //initialize the variables
         ref = DatabaseReference()
         arrTaskData = NSMutableArray()
        
        //we initialize localDB with our database file name
        localDB = SKDatabase(file: "TodoListDB.sqlite")
        
        //for set tableview Height based on content size
        tblListTask.estimatedRowHeight =  UITableView.automaticDimension
        tblListTask.rowHeight = UITableView.automaticDimension
      
        
        //for monitor offline Changes that will Sync when user connected to the internet
        self.ref.database.isPersistenceEnabled = true
    
      //this will create Task list Node inside FirebaseRealtime Database
        ref =  Database.database().reference().child("TaskList");
        
      //** database observe block that will called every time when Insert,update,delete,create actions is perfomed  in firebase realtime database **//
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
           
            //check if the reference have some values
            if snapshot.childrenCount >= 0 {
                
                //clearing the tasklist for update the local database  with firebase realtime database changes
               
                //delete Query
                let QueryDelete = "DELETE FROM tblListTask"
               
                 //performSQL is method of our SKDatabase Wrapper Class for run SQl query
                localDB?.performSQL(QueryDelete)
                
                
                //iterating through all the values
                for tasks in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values from tasks
                    let taskObject = tasks.value as? [String: AnyObject]
                    
                    //getting values from from taskObject using firebase realtime database key
                    let taskId  = taskObject?["id"]
                    let taskName  = taskObject?["taskName"]
                    let taskDetails = taskObject?["taskDetails"]
                    let taskDate = taskObject?["taskDate"]
                    let taskTime = taskObject?["taskTime"]
                    
                    //for Prevent app Crash if Data not inseted Currectlly from firebase console
                    if taskName == nil || taskId  == nil || taskDetails == nil{
                       
                        //Data are not Inserted correctlly from Firebase
                        print("Wrong Data Formate or missing Values")
                        
                    }else{
                     //insert data in  local database
                        let Query = "INSERT INTO tblListTask(task_ID,task_Name,task_Details,task_Date,task_Time)VALUES('\(taskId!)','\(taskName!)','\(taskDetails!)','\(taskDate!)','\(taskTime!)')"
                        
                        //performSQL is method of our SKDatabase Wrapper Class for run SQl query
                        localDB?.performSQL(Query)
                        
                    }
                    
                }
                //reloading the tableviewData
                self.tblListTask.reloadData()
            }
            //For Capture changes from Firebase Console
            //** the Below GetTaskMethod Only Called When user  is connected with internet **//
            self.getTaskList()
        })
        
        //For Capture Offline local Db Changes(this will capture the offline Added Task)
         self.getTaskList()

    }

    
    func getTaskList(){
    
        //select Query for  retrive the task list from localDB
    let selectQuery = "SELECT * FROM tblListTask"
        
        //lookupAll is method of our SKDatabase Wrapper Class for select statement
    let data = localDB.lookupAll(forSQL: selectQuery) //store the result of select query
       
        //temp array for store NSArray response
        let arrTempData = data! as NSArray
        
        //convert the arrTempdata in nsmutableArray & assign to the arrTaskData
        arrTaskData =  arrTempData.mutableCopy() as? NSMutableArray
        
        //reload tableview for update the data
        tblListTask.reloadData()
        
        //check the array empty or not
        if arrTaskData.count == 0{
            
            //Display empty task list alert message
            self.popupAlert(title: ALERTTITLE, message: "No Saved Task Found")
        }
    }
    
    //MARK:- Tableview Delegate & DataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrTaskData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //initialize the the custom tableview cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TblCellListTask", for: indexPath)as! TblCellListTask
       ///Remove white space of cell separator line
        cell.separatorInset = UIEdgeInsets.zero;
        
        //display the taskName,taskDetails,taskDate,taskTime values in tablview from arrTaskData object
        cell.lblTaskTitle.text = ((arrTaskData.object(at: indexPath.row)as! NSDictionary).value(forKey: "task_Name") as! String)
        cell.lblTaskDetails.text = ((arrTaskData.object(at: indexPath.row)as! NSDictionary).value(forKey: "task_Details") as! String)
        cell.lblTaskDate.text = ((arrTaskData.object(at: indexPath.row)as! NSDictionary).value(forKey: "task_Date") as! String)
        cell.lblTaskTime.text = ((arrTaskData.object(at: indexPath.row)as! NSDictionary).value(forKey: "task_Time") as! String)
        
        //returning tableview cell
        return cell
    }
    
   //For set Height of Uitableview Custom Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //we return the automaticHeight because we set the cell height based on content
        return UITableView.automaticDimension
    }
    //to set the estimated height for cell
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        //we return the automaticHeight because we set the cell height based on content
        return UITableView.automaticDimension
    }
    
  //for enable edting(edit delete) in tableview when swipe
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    //for edit delete task on swipe cell
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        //creating the deleteAction
        let deleteAction = UITableViewRowAction(style: .normal, title: "delete") { action, index in
           //Handle the delete Action
           
            //Delete record from firebase database
            
             //Id that Contains Firebase database
            let postID = ((self.arrTaskData.object(at: editActionsForRowAt.row)as! NSDictionary).value(forKey: "task_ID") as! String)
            
            //** this will Call database observer (inside view Didload) again **//
            Database.database().reference().child("TaskList").child("\(postID)").removeValue()
            
            //For delete from  local database that will Sync to the firebase database
            let deleteQuery = "DELETE FROM tblListTask WHERE task_ID = '\(postID)' "
            
            //performSQL is method of our SKDatabase Wrapper Class for run SQl query
            localDB.performSQL(deleteQuery)
            
            //called getTasklist for retrive the updated data from localDatabase
            self.getTaskList()
            
        }
        //set color of deleteButton
        deleteAction.backgroundColor = .red
        
        //creating the editAction
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
        
            //Handle the editAction
            
            self.dicSelectedTask = ((self.arrTaskData.object(at: editActionsForRowAt.row)) as! NSDictionary)
            let EditTaskView = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskDetails")as! AddTaskDetails
            EditTaskView.dicValuesEdit = self.dicSelectedTask
           self.navigationController?.pushViewController(EditTaskView, animated: true)
            
            
        }
        
        //set color of editButton
        editAction.backgroundColor = .orange
        
        //returning the both action
        return [deleteAction, editAction]
    }

}
