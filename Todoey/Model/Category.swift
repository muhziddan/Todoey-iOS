//
//  Category.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 06/12/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
