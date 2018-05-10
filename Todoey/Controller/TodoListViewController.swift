//
//  ViewController.swift
//  Todoey
//
//  Created by Ryan Chingway on 5/7/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    var itemArray = [TodoListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "TodoList") as? [TodoListItem] {
            itemArray = items
        }
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator -> value = condition ? true:false
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add Item to List
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()   //Capture text field from UIAlert
        
        let alert = UIAlertController(title: "Add New Item", message: "Add new item to ToDo List", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = TodoListItem()
            
            if let newTitle = textField.text {
                newItem.title = newTitle
                self.itemArray.append(newItem)
                //self.defaults.set(self.itemArray, forKey: "TodoList")
            }
            
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Todoey item..."
            textField = alertTextField      //To get text to larger scope
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

