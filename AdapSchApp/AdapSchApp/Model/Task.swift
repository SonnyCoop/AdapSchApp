//
//  Task.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import Foundation
import RealmSwift

class Task: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var time: Int
    @Persisted var dueDate: String
    @Persisted var blockLenghts: Int = 60
    @Persisted var priority: Int = 5
    @Persisted var timeOfDay: String = "Any"
    @Persisted var weekTask: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
    
    override class func primaryKey() -> String? {
        "id"
    }
}
