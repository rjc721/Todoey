//
//  ViewController.swift
//  Todoey
//
//  Created by Ryan Chingway on 5/7/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()

    var category: Category? {
        didSet {
            loadItems()
            self.navigationItem.title = category?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let doneStatus = todoItems?[indexPath.row].done {
            cell.accessoryType = doneStatus ? .checkmark : .none
        }
        
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Items Added Yet"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
            
        }

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add Item to List
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()   //Capture text field from UIAlert
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let currentCategory = self.category {
                
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print("Error saving item: \(error)")
                }
            }
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New item..."
            textField = alertTextField      //To get text to larger scope
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Loading Items
    func loadItems() {
        todoItems = category?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: Update Model
    override func updateModel(at indexPath: IndexPath) {
        
        if let swipedItem = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(swipedItem)
                }
                
            } catch {
                print("Problem deleting item: \(error)")
            }
            
        }
    }
    
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated")
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

