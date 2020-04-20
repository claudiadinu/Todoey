//
//  ViewController.swift
//  Todoey
//
//  Created by Claudia Dinu on 05/04/2020.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    var itemArray = [Item]()
    
    //optional variable - bc it's going to be nil until we set it in CategoryVC
    var selectedCategory : Category? {
        //this happens as soon as the selectedCategory var is set with a value
        didSet {
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    //we need an intance of AppDelegate tp access its properties
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //file path to view core data -> Library -> Application Support
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //2 options for the table view, local variable and global variable (bc of the UITableViewController extension)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //the row of the current index path
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //update the item - setValue function
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //delete item
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        //sets the done attribute to the opposite - reversing what it used to be
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //after the user selects the row, it becomes gray, but after a second it's deselected and becomes white
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user click the Add button on our UIalert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            //we need to set a value for done in order to have the item saved (and not have a nil valuefor done property)
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField //store a reference to the alertTextField in a local variable
            //print(alertTextField.text)  //will print Optional("") as the textfield is empty when the alert appears
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    //using core data for saving our new items
    func saveItems(){
        do{
            //save that sketch, data found in temporary area becomes permanent
            try context.save()
        }
        catch {
            print("Error saving context, \(error)")
        }
        
        //item was added in the array, but the table view needs to be changed
        self.tableView.reloadData()  // forces the table view to call its data source methods again
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        //the entity you are trying to request data from is mandatory
        //we provide a default value to be used in viewDidLoad()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    

}

//MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        //for all the items in the itemArray look for the ones where the title contains this text
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //request.predicate = predicate
        
        //items sorted asc by title
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                //cursor and keyboard should go away - on the main thread
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

