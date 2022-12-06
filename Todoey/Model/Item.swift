//
//  Item.swift
//  Todoey
//
//  Created by Muhammad Ziddan Hidayatullah on 06/12/22.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var state: Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
