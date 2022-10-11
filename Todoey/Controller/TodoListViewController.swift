//
//  ViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 05/10/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var array = [MainModel]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "Items.plist")
    // user domain mask is user home directory, a place where app will save personal item ssociated with it

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        array.append(MainModel(item: "one", state: false))
        array.append(MainModel(item: "two", state: false))
        array.append(MainModel(item: "three", state: false))
        array.append(MainModel(item: "three", state: false))
        array.append(MainModel(item: "two", state: false))
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
            
            self.array.append(MainModel(item: safeText, state: false))
            self.saveData()
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
    
    func saveData() {
        // make encoder object
        let encoder = PropertyListEncoder()
        
        do {
            // encode data to plist
            let data = try encoder.encode(array)
            guard let safeFilePath = dataFilePath else {return}
            try data.write(to: safeFilePath)
        } catch {
            print("error saving data with message: \(error.localizedDescription)")
        }
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
        
        cell.textLabel?.text = currentItem.item
        cell.accessoryType = currentItem.state ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        array[indexPath.row].state = !array[indexPath.row].state
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}

