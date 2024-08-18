//
//  Item.swift
//  Todoey
//
//  Created by Harshit ‎ on 8/15/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
//    Date().timeIntervalSinceReferenceDate
//    @objc dynamic var dateCreated: Date =
    
    // Inversr relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
