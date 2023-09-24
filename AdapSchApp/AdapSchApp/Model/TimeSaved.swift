//
//  TimeSaved.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 16/09/2023.
//

import Foundation
///what is saved to the plist
struct TimeSaved: Codable {
    var taskId: String = ""
    var startTime: Date? = Date()
    var pauseTime: Date = Date()
    var paused: Bool = false
    var timeBlock: Int = 0
}
