//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Ryan Chingway on 5/11/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    

    //MARK: Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //prepare for segue
        performSegue(withIdentifier: "goToItems", sender: categoryArray[indexPath.row])
        
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Category", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            if let text = textField.text {
                newCategory.name = text
            }
            
            self.categoryArray.append(newCategory)
            self.saveData()
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
    
    //MARK: Load/Save Data
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Error saving category: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching categories: \(error)")
        }
        
        
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? TodoListViewController {
            
            destinationVC.category = sender as? Category
                
        }
    }
}
