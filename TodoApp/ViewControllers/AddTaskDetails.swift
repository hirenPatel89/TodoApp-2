//
//  AddTaskDetails.swift
//  TodoApp
//
//  Created by Shreeji on 12/06/19.
//  Copyright © 2019 Shreeji. All rights reserved.
//

import UIKit
import Firebase

class AddTaskDetails: UIViewController,UITextFieldDelegate {
    
    //firebase Database Reference
    var firRefDB: DatabaseReference!
    
    //For store editTask Values when user select edit action from ListTask screen
    var dicValuesEdit:NSDictionary!
    
    //textFields Outlets
    @IBOutlet weak var txtTaskTitle: UITextField!
    @IBOutlet weak var txtTaskDescription: UITextField!
    @IBOutlet weak var txtTaskDate: UITextField!
    @IBOutlet weak var txtTaskTime: UITextField!
    
   
    //** we have used btnAddTask for both action editTaskDetails and Add task **//
    
    @IBOutlet weak var btnAddTask: UIButton!  //addTask buttton Outlet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
      //** check if dicValuesEdit have Values or not if dicValuesEdit have values that means user want to Edit the task detils otherwise we add new task **//
        
        if dicValuesEdit != nil{
            //data in dicValuesEdit are comes from listTaskView Screen
            /** Display the edit Task details values in textFields from dicValuesEdit Dictionary **/
            
            //
            print("Edit Task")
            btnAddTask.setTitle("Edit Task", for: .normal)
            txtTaskTitle.text = (dicValuesEdit.value(forKey: "task_Name") as! String)
            txtTaskDescription.text = dicValuesEdit.value(forKey: "task_Details") as? String
            txtTaskDate.text = dicValuesEdit.value(forKey: "task_Date") as? String
            txtTaskTime.text = dicValuesEdit.value(forKey: "task_Time") as? String
        
            
        }else{
            
            //set the btn Title values based on user selected Action (EditTask,AddTask)
             btnAddTask.setTitle("Add Task", for: .normal)
             print("Add Task")
            
        }
            //print(arrValuesEdit!)
       
      
      
        //** initialize the firRefDB instance **//
        firRefDB =  Database.database().reference().child("TaskList");
      
        //** Assign the Delegate to textFields **//
        txtTaskTitle.delegate = self
        txtTaskDescription.delegate = self
        txtTaskDate.delegate = self
        txtTaskTime.delegate = self
        
        
        
    }
    
    func addTask(){
        // Creates  a new key inside TaskList node //
   
        /* we use this Key  for edit delete data in firebase realtime database & local database.
         values of key are always unique
         */
        
        let key = firRefDB.childByAutoId().key
        
        //creating task from textfileds values this keys and values will show in firebase DB
        
        let Task = ["id":key,
                    "taskName": txtTaskTitle.text,
                    "taskDetails":txtTaskDescription.text,
                    "taskDate":txtTaskDate.text,
                    "taskTime":txtTaskTime.text
            
        ]
        
        //adding the Task inside the generated unique key
        firRefDB.child(key!).setValue(Task)
        
        
        //Add data in LocalDb to see offline becuase firebase RealTime database sync data when user is connected with internet
        let Query = "INSERT INTO tblListTask(task_ID,task_Name,task_Details,task_Date,task_Time)VALUES('\(key!)','\(txtTaskTitle.text!)','\(txtTaskDescription.text!)','\(txtTaskDate.text!)','\(txtTaskTime.text!)')"
        
        //performSQL is method of our SKDatabase Wrapper Class for run SQl query
        localDB?.performSQL(Query)
        
         //displaying  success alert message
        popupAlert(title: ALERTTITLE, message: "Task Added Successfully")
       
        
    }
    
    
    /**
     This method will update the record in firebase database
     
     This method accepts a String representing task details.
     
     To use it, simply call
     
     here i am passsed the values of textfiels you can pass any string based on your requirement
     updateTask(id: taskId, name: txtTaskTitle.text!, details: txtTaskDescription.text!, date: txtTaskDate.text!, time: txtTaskTime.text!)
     
     - Parameter id: id of task that user wants to update
     - Parameter name: value for taskName
     - Parameter details: value for taskDetails
     - Parameter date: value for taskDate
     - Parameter time: value for taskTime
     
     */
    
    func updateTask(id:String, name:String, details:String,date:String,time:String){
        //creating  taskData Dictionary with the new given values
        
        //KEYS are Firebase DB KEYs
        let TaskData = ["id":id,
                        "taskName": name,
                        "taskDetails": details,
                        "taskDate":date,
                        "taskTime":time
        ]
        
        //updating the taskrecord using the key of the TaskData
        firRefDB.child(id).setValue(TaskData)
        
       
        
    }
    
    
    //MARK:- TextField Delegate Methods
    
    //for prevent the space at start writing in textFields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }
        
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
    
    
    //MARK:- IBAction
    
    @IBAction func btnAddTaskClicked(_ sender: Any) {
    
        //set validation before add update the Task
        
        
        //check the taskTitle should not empty
        if txtTaskTitle.text?.count == 0{
        
            popupAlert(title: ALERTTITLE, message: "Please Enter Task Title")
        
        }else if txtTaskDescription.text!.count <= 10{ //Task description must be contains at list 10 characters
            
            popupAlert(title: ALERTTITLE, message: "Task Description Contains At List 10 characters")
            
        }else if txtTaskDate.text?.count == 0{  //check the taskDate should not empty
            
            popupAlert(title: ALERTTITLE, message: "Please Enter Task Date")
            
        }else if txtTaskTime.text?.count == 0{  //check the taskTime should not empty
            
            popupAlert(title: ALERTTITLE, message: "Please Enter Task Time")
            
        }else{
            //check dicValues to know the Add or Edit Action
               if dicValuesEdit != nil{
                //dicvaluesEdit contains values that means edit Task
               let taskId = self.dicValuesEdit.value(forKey: "task_ID")as! String;
                print(taskId)
                self.updateTask(id: taskId, name: txtTaskTitle.text!, details: txtTaskDescription.text!, date: txtTaskDate.text!, time: txtTaskTime.text!)
                self.popupAlert(title: ALERTTITLE, message: "Task Updated SuccessFully")
               }else{
                
                //dicvaluesEdit are empty so we add the new task
               self.addTask()
              }
          }
        
    }
    
   //for show the date picker when click on  date textField
    @IBAction func chooseTaskDate(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        //set the datepicker mode
        datePickerView.datePickerMode = .date
        sender.inputView = datePickerView
        //handleDatePicker called when user selected the date
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
     //for show the time picker when click on time textField
    @IBAction func chooseTaskTime(_ sender: UITextField) {
        let datePickerView = UIDatePicker()
        
        //set the datepicker mode
        datePickerView.datePickerMode = .time
        sender.inputView = datePickerView
          //handleDatePicker called when user selected the time
        datePickerView.addTarget(self, action: #selector(handleTimePicker(sender:)), for: .valueChanged)
    }
    
    //set seleted date in textfield
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
         // Set the date format
        dateFormatter.dateFormat = "dd MMM yyyy"
        txtTaskDate.text = dateFormatter.string(from: sender.date) //set the selected date in textField
    }
    
     //set seleted time in textfield
    @objc func handleTimePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
         // Set the time format
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.locale = NSLocale.system
        txtTaskTime.text = dateFormatter.string(from: sender.date) //set the selected Time 
       
        
    }
    
}
