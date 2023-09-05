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
    @Persisted var dueDate: Date
    @Persisted var blockLenghts: Int = 60
    @Persisted var priority: Int = 5
    @Persisted var timeOfDay: String = "Any"
    @Persisted var weekTask: Bool = false
    @Persisted(originProperty: "tasks") var parentCategory: LinkingObjects<Category>
    
    override class func primaryKey() -> String? {
        "id"
    }
}
