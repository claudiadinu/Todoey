//
//  ViewController.swift
//  Todoey
//
//  Created by Claudia Dinu on 05/04/2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
//    var itemArray = ["Find Mike", "Buy Eggs", "Play Drawful", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o"]
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        let newItem2 = Item()
        newItem2.title = "Buy Eggs"
        itemArray.append(newItem2)
        let newItem3 = Item()
        newItem3.title = "Play Drawful"
        itemArray.append(newItem3)
        
        //previously we were retrieving an array of Strings
        //retrieve data from itemArray
        if let items = UserDefaults.standard.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //2 options for the table view, local variable and global variable (bc of the UITableViewController extension)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //the row of the current index path
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else{
//            cell.accessoryType = .none
//        }
        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else{
//            itemArray[indexPath.row].done = false
//        }
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //sets the done attribute to the opposite - reversing what it used to be
        
        tableView.reloadData()  // forces the table view to call its data source methods again
        
        //add/remove checkmark whenever a cell is selected
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        //after the user selects the row, it becomes gray, but after a second it's deselected and becomes white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user click the Add button on our UIalert
            //print(textField.text)
            //we can prevent the execution of this line of code if textField is empty
            //self.itemArray.append(textField.text!)
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //store the array in the user defaults with a given key
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            //item was added in the array, but the table view needs to be changed
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //store a reference to the alertTextField in a local variable
            //print(alertTextField.text)  //will print Optional("") as the textfield is empty when the alert appears
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    


}

