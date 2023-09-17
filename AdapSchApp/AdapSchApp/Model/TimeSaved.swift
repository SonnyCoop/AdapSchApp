//
//  TimeSaved.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 16/09/2023.
//

import Foundation
///what is saved to the plist
struct TimeSaved: Codable {
    var startTime: Date? = Date()
    var pauseTime: Date = Date()
    var paused: Bool = false
}
