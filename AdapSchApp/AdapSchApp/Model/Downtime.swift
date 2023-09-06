//
//  Downtime.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 05/09/2023.
//

import Foundation
import RealmSwift

class Downtime: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var days: List<String>
    @Persisted var start: Date
    @Persisted var end: Date
    
    override class func primaryKey() -> String? {
        "id"
    }
}
