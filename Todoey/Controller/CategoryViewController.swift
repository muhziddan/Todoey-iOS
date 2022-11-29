//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 29/11/22.
//

import UIKit

class CategoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
}

// MARK: - Table view data source
extension CategoryViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
