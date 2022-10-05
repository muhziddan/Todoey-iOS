//
//  ViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 05/10/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var array: [String] = []
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            array = items
        }
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
            
            self.array.append(safeText)
            self.defaults.set(self.array, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alertView.addTextField { alertTextField in
            textField.placeholder = "Type new item"
            // This where textField var referencing alertTextField
            textField = alertTextField
        }
        
        alertView.addAction(action)
        
        present(alertView, animated: true)
    }
}

//MARK: - TableView Datasource and Delegate Methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = array[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.accessoryType == .checkmark ? (selectedCell?.accessoryType = .none) : (selectedCell?.accessoryType = .checkmark)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

