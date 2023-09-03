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
    
    override class func primaryKey() -> String? {
        "id"
    }
}