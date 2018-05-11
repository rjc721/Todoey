//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ryan Chingway on 5/11/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    

    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: categories?[indexPath.row])
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            do {
                try self.realm.write {
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    self.realm.add(newCategory)
                }
            } catch {
                print("Error saving category: \(error)")
            }
            
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField
            {   (alertTextField) in
                alertTextField.placeholder = "Add New Category"
                textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Load Data
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TodoListViewController {
            
            destinationVC.category = sender as? Category
        }
    }
}
