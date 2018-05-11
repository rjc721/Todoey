//
//  TodoListItem.swift
//  Todoey
//
//  Created by Ryan Chingway on 5/10/18.
//  Copyright © 2018 Ryan Chingway. All rights reserved.
//

import Foundation

class TodoListItem: Encodable, Decodable {
    var done: Bool = false
    var title = ""
}
