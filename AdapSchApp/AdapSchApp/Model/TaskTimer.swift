//
//  Timer.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 13/09/2023.
//

import SwiftUI

class TaskTimer: ObservableObject {
    /// String to show in UI
    @Published private(set) var message = "Not running"

    /// Is the timer running?
    @Published private(set) var isRunning = false

    /// Time that we're counting from
    private var startTime: Date? = nil
    private var pauseTime: Date = Date()
    private var wasPaused = false

    /// The timer
    private var timer = Timer()

    ///  Whether the time session is officially finished
    private var overtime = false

    init() {
        startTime = fetchStartTime()

        if startTime != nil {
            start()
        }
    }
}

//MARK: - stop watch functionality
extension TaskTimer {
    func start(){
        if startTime == nil {
            startTime = fetchStartTime()
        }
        fire()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        
    }
    
    func pause(){
        timer.invalidate()
        pauseTime = Date()
        wasPaused = true
    }
    
    
    func inOvertime(){
        overtime = true
    }
    
    //runs each second
    @objc func fire()
    {
        let now = Date()
        if wasPaused, let tempStartTime = startTime {
            startTime = tempStartTime + (now - pauseTime)
            saveStartTime()
            wasPaused = false
        }
        let elapsed = Int(now - startTime!)
        self.message = updateTimer(time: elapsed)
    }
    
    func updateTimer(time: Int) -> String{

        let totalHrs = time / 3600
        var totalSecs = time % 3600
        let totalMins = totalSecs / 60
        totalSecs = totalSecs % 60
        
        //turning it into strings
        let stringMins = totalMins / 10 == 0 ? "0\(totalMins)" : "\(totalMins)"
        let stringSecs = totalSecs / 10 == 0 ? "0\(totalSecs)" : "\(totalSecs)"
        
        var timerString = ""
        
        if totalHrs == 0 {
            timerString = stringMins+":"+stringSecs
        }
        else {
            timerString = "\(totalHrs):"+stringMins+":"+stringSecs
        }
    
        if overtime{
            return "+ "+timerString
        }
        return timerString
    }
}

//MARK: - saving data
extension TaskTimer {
    func saveStartTime(){
        //change this to save to plist
        
    }
    func fetchStartTime() -> Date?{
        //change this to fetch from plist
        return Date()
    }
}
