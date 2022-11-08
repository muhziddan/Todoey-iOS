//
//  ViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 05/10/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var array = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // core data: context is to trigger the persistent container -> the managed object

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        // to check persistent container/SQLite database directory of the app
        
        loadData()
    }
    
    //MARK: - Add new Item
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        // Make the UI Alert View (the root alert view)
        let alertView = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        // Make the action that it taken when user tap the alert button
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // Text can be updated because textField var referencing the alertTextField
            // So when it is called, it can get the latest text from the alertTextField
            guard let safeText = textField.text else {return}
            
            let newItem = Item(context: self.context)
            newItem.title = safeText
            newItem.state = false
            
            self.array.append(newItem)
            self.saveData()
        }
        
        alertView.addTextField { alertTextField in
            alertTextField.placeholder = "Type new item"
            // This where textField var referencing alertTextField
            textField = alertTextField
        }
        
        alertView.addAction(action)
        
        present(alertView, animated: true)
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("error saving data with message: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            array = try context.fetch(request)
        } catch {
            print("error fetching data with message: \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - TableView Datasource and Delegate Methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let currentItem = array[indexPath.row]
        
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.state ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        array[indexPath.row].state = !array[indexPath.row].state
        
        // if want to delete item
//        context.delete(array[indexPath.row])
//        array.remove(at: indexPath.row)
        
        saveData()
    }
}

//MARK: - Search Bar Delegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = Item.fetchRequest()
        
        // making the filter using predicate
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text ?? "")
        
        // sorting the result
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request)
    }
}
