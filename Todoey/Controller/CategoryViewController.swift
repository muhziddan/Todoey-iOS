//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 29/11/22.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    // category array has to be a Results type, because realm.objects will return the results<> type not array of category
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alertView = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            guard let safeText = textField.text else {return}
            
            if !safeText.isEmpty {
                // using realm will decrease the boiler plate made by core data
                // it doesn't need to use a context and appending, because it already handle the dynamic changes of the data because of an auto-updating container feature
                let newCategory = Category()
                newCategory.name = safeText
                
                self.save(category: newCategory)
            }
        }
        
        alertView.addTextField { alertTextField in
            alertTextField.placeholder = "Type new Category"
            textField = alertTextField
        }
        
        alertView.addAction(action)
        present(alertView, animated: true)
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving data with message: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func delete(category: Category) {
        
        let childItem = realm.objects(Item.self).filter("ANY parentCategory == %@", category)
        do {
            try realm.write {
                realm.delete(childItem)
                realm.delete(category)
            }
        } catch {
            print("error deleting category data with message: \(error)")
        }
    }
}

// MARK: - Table view data source
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let currentCategory = categoryArray?[indexPath.row]
        cell.textLabel?.text = currentCategory?.name ?? "No categories added yet"
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        
        destinationVC.selectedCategory = categoryArray?[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let selectedCategory = categoryArray?[indexPath.row] else {return UISwipeActionsConfiguration()}
        
        let deleteCategory = UIContextualAction(style: .destructive, title: "") { action, view, completionHandler in
            self.delete(category: selectedCategory)
            self.tableView.deleteRows(at: [indexPath], with: .top)
        }
        
        deleteCategory.image = UIImage(systemName: "trash.fill")
        deleteCategory.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteCategory])
        
        return configuration
    }
}
