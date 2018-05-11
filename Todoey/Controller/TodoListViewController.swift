//
//  ViewController.swift
//  Todoey
//
//  Created by Ryan Chingway on 5/7/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoListItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var category: Category? {
        didSet {
            loadItems()
            self.navigationItem.title = category?.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let category = category {
//            self.navigationItem.title = category.name
//        }
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
    
    //MARK: Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: Add Item to List
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()   //Capture text field from UIAlert
        
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newItem = TodoListItem(context: self.context)
            
            if let newTitle = textField.text {
                newItem.title = newTitle
                newItem.parentCategory = self.category
                self.itemArray.append(newItem)
            
                self.saveItems()
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
    
    //MARK: Decoding/Encoding Data for Storage
    func loadItems(with request: NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest(), predicate: NSPredicate? = nil) {
  
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", category!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
        }
        tableView.reloadData()
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<TodoListItem> = TodoListItem.fetchRequest()
        
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = searchPredicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: searchPredicate)
    
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

