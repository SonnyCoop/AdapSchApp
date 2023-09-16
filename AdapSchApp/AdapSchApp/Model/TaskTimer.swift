//
//  Timer.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 13/09/2023.
//

import SwiftUI

class TaskTimer: ObservableObject {
    /// where the start time is saved
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TimesSaved.plist")
    /// String to show in UI
    @Published private(set) var message = "Not running"

    /// Is the timer running?
    @Published private(set) var isRunning = false

    /// Time that we're counting from
    private var startTime: Date? = nil
    private var pauseTime: Date = Date()
    private var wasPaused = false
    private var sessionBlock: Int
    private var time: Int

    /// The timer
    private var timer = Timer()

    ///  Whether the time session is officially finished
    private var overtime = false

    init(sessionBlock: Int) {
        self.sessionBlock = sessionBlock
        self.time = sessionBlock
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
        setPauseTime()
    }
    
    //runs each second
    @objc func fire()
    {
        let now = Date()
        if wasPaused, let tempStartTime = startTime {
            startTime = tempStartTime + (now - pauseTime)
            wasPaused = false
            setPauseTime()
        }
        let elapsed = Int(now - startTime!)
        if overtime{
            time = elapsed - sessionBlock
        }
        else if sessionBlock == 0 {
            time = elapsed - sessionBlock
            overtime = true
        }
        else{
            time = sessionBlock - elapsed
        }
        
        self.message = updateTimer()
    }
    
    func updateTimer() -> String{

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

//MARK: - Getter and Setter methods
extension TaskTimer {
    func percentDone() -> Double{
        if overtime {
            return 0
        }
        else{
            return Double(time)/Double(sessionBlock)
        }
    }
    
    func clearStartTime(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(TimeSaved(startTime: nil))
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding item array, \(error)")
        }
    }
}

//MARK: - saving data
extension TaskTimer {
    func saveStartTime(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(TimeSaved())
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding item array, \(error)")
        }
    }
    
    func fetchStartTime() -> Date?{
        //change this to fetch from plist
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                let dataRetrived = try decoder.decode(TimeSaved.self, from: data)
                if let timeSaved = dataRetrived.startTime{
                    pauseTime = dataRetrived.pauseTime
                    wasPaused = dataRetrived.paused
                    return timeSaved
                }
            }catch{
                print("error decoding item array, \(error)")
            }
            
        }
        saveStartTime()
        return Date()
    }
    
    func setPauseTime(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(TimeSaved(startTime: startTime, pauseTime: pauseTime, paused: wasPaused))
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding item array, \(error)")
        }
    }
}
