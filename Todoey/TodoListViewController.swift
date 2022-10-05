//
//  ViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 05/10/22.
//

import UIKit

class TodoListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
}

//MARK: - TableView Datasource Methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = "Test"
        
        return cell
    }
    
    
}

