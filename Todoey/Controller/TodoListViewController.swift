//
//  ViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 05/10/22.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    // item array has to be a Results type, because realm.objects will return the results<> type not array of category
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            
            if !safeText.isEmpty, let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = safeText
                        // to set the item parent object, it sets from the parent itself (using the selectedCategory)
                        // form there, chain the relation property (items), then append the new item
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error saving items with description: \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alertView.addTextField { alertTextField in
            alertTextField.placeholder = "Type new item"
            // This where textField var referencing alertTextField
            textField = alertTextField
        }
        
        alertView.addAction(action)
        
        present(alertView, animated: true)
    }
    
    func loadData() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
}

//MARK: - TableView Datasource and Delegate Methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        guard let currentItem = todoItems?[indexPath.row] else {
            cell.textLabel?.text = "no items added yet"
            return cell
        }
        
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.state ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // check if selected item is not nil
        guard let selectedItem = todoItems?[indexPath.row] else {return}
        
        do {
            try realm.write {
                // update data using realm also done under the realm.write function
                selectedItem.state = !selectedItem.state
            }
        } catch {
            print("error updating state of items with message: \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search Bar Delegate
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text else {return}

        if text.isEmpty {
            loadData()
        } else {
            // using core data, it do not need to load the data again, simply just filter the current data
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", text).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }

        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {return}

        if text.isEmpty {
            loadData()
        }
    }
}
