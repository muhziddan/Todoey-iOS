//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 29/11/22.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
                let newCategory = Category(context: self.context)
                newCategory.name = safeText
                
                self.categoryArray.append(newCategory)
                self.saveData()
            }
        }
        
        alertView.addTextField { alertTextField in
            alertTextField.placeholder = "Type new Category"
            textField = alertTextField
        }
        
        alertView.addAction(action)
        present(alertView, animated: true)
    }
    
    func saveData()  {
        do {
            try context.save()
        } catch {
            print("error saving data with message: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        let request = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error fetching data with message: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
}

// MARK: - Table view data source
extension CategoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let currentCategory = categoryArray[indexPath.row]
        cell.textLabel?.text = currentCategory.name
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        
        destinationVC.selectedCategory = categoryArray[indexPath.row]
    }
}
