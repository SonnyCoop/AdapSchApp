//
//  Category.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 04/09/2023.
//

import Foundation
import RealmSwift

class Category: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var totalTime: Int
    @Persisted var color: List<String>
    let tasks = List<Task>()
    
    override class func primaryKey() -> String? {
        "id"
    }
}
