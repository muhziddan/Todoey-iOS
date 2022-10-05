//
//  ViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 05/10/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let array = ["A", "B", "C"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

