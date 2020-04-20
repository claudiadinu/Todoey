//
//  Category.swift
//  Todoey
//
//  Created by Claudia Dinu on 20/04/2020.
//  Copyright © 2020 test. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    //list of items initialised as empty
    let items = List<Item>()
}
