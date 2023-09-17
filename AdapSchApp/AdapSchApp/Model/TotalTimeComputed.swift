//
//  TotalTimeComputed.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 17/09/2023.
//

import Foundation
class TotalTimeComputed: ObservableObject{
    var task: Task
    @Published private(set) var totalHours: Int = 0
    @Published private(set) var totalMins: Int = 0
    private var totalTime: Int {
        get{
            return task.time
        }
        set{
            totalHours = newValue / 60
            totalMins = newValue % 60
        }
    }
    init(task: Task){
        self.task = task
        self.totalTime = task.time
    }
    
    func addTime(mins timeToAdd: Int){
        totalTime = totalHours * 60 + totalMins + timeToAdd
    }
    
    func subTime(mins timeToSub: Int){
        let newTime = totalHours * 60 + totalMins - timeToSub
        if newTime > 0{
            totalTime = newTime
        }
    }
    
    func getTotal() -> Int {
        return totalHours * 60 + totalMins
    }
}
