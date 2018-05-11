//
//  Category.swift
//  Todoey
//
//  Created by Ryan Chingway on 5/11/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
