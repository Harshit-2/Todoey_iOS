//
//  Category.swift
//  Todoey
//
//  Created by Harshit ‎ on 8/15/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    // Forward relationship
    let items = List<Item>()
}
