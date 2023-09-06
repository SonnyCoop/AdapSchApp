//
//  Category.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 04/09/2023.
//

import Foundation
import RealmSwift

class Category: Object, Identifiable {
    @Persisted (primaryKey: true) var title: String
    @Persisted var totalTime: Int = 0
    @Persisted var color: List<String>
    @Persisted var tasks: List<Task>
}
