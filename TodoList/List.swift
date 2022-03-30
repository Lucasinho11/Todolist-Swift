///Users/lucas/Documents/Code👨🏻‍💻/swift🍎/TodoList/TodoList/ListViewController.swift
//  List.swift
//  TodoList
//
//  Created by Lucas Lubasinski on 17/02/2022.
//

import Foundation

struct List: Codable, Equatable {
    var name: String?
    var task: [Task]?
}
