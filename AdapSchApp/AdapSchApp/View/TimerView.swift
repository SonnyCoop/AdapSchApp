//
//  TimerView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 08/09/2023.
//

import SwiftUI
import RealmSwift

struct TimerView: View {
    var task: Task = Task()
    
    /// where the start time is saved
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TimesSaved.plist")
    
    //task.blockLengths in seconds
    @State var timeBlock: Int = 0
    @State var totalTimeDone: Int = 0

    //timer variables
    @State private var timerType: TimerType = .regular
    @State private var paused: Bool = false
    @State private var overtime: Bool = false
    @ObservedObject private var taskTimer: TaskTimer = TaskTimer(sessionBlock: 0, taskId: "")
    
    //total time hours and mins
    @ObservedObject private var totalTimeComputed: TotalTimeComputed = TotalTimeComputed(task: Task())
    
    init(){
        //change this to fetch from plist
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            let dataRetrived = try! decoder.decode(TimeSaved.self, from: data)
            if let timeSaved = dataRetrived.startTime{
                let tempTask = findTask(id: dataRetrived.taskId)
                self.task = tempTask
                _timeBlock = State(initialValue: dataRetrived.timeBlock)
                _totalTimeDone = State(initialValue: self.task.timeDone)
                self.taskTimer = TaskTimer(sessionBlock: dataRetrived.timeBlock, taskId: tempTask.id.stringValue)
                totalTimeComputed = TotalTimeComputed(task: tempTask)
                self.paused = taskTimer.isPaused()
            }
        }
    }
    
    init(task: Task, timeBlock: Int, totalTimeDone: Int) {
        self.task = task
        _timeBlock = State(initialValue: timeBlock)
        _totalTimeDone = State(initialValue: totalTimeDone)
        self.taskTimer = TaskTimer(sessionBlock: timeBlock, taskId: task.id.stringValue)
        totalTimeComputed = TotalTimeComputed(task: task)
        self.paused = taskTimer.isPaused()
    }
    
    @State private var completed: Bool = false
    
    //add for different timers e.g. 25-5 timer
    enum TimerType: String, CaseIterable, Identifiable {
        case regular
        var id: Self { self }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    //realm setup
    let realm = try! Realm()
    @ObservedResults(Task.self) var tasks
    
    var body: some View {
        NavigationView{
            ZStack{
                //background colour
                K.Colors.background1.ignoresSafeArea()
                VStack{
                    Picker("", selection: $timerType){
                        Text("Regular").tag(TimerType.regular)
                    }
                    .background(Rectangle()
                        .fill(K.Colors.background1)
                        .border(K.Colors.background2))
                    Spacer()
                    //MARK: - Timer
                    ZStack{
                        CircularProgressBar(progress: taskTimer.percentDone())
                            .frame(width: 200, height: 200)
                        VStack{
                            Text(taskTimer.message)
                                .padding()
                            Button{
                                paused = !paused
                                if paused {
                                    taskTimer.pause()
                                }
                                else{
                                    taskTimer.start()
                                }
                            } label: {
                                Image(systemName: paused ? "play.fill" : "pause.fill")
                                    .padding()
                            }
                        }
                    }
                    
                    Spacer()
                    //MARK: - Total Progress
                    HStack{
                        if completed || totalTimeDone >= totalTimeComputed.getTotal() {
                            ProgressView(value: 1, total: 1)
                                .padding(.leading, 15)
                                .tint(K.Colors.tab)
                        }
                        else{
                            ProgressView(value: Float(totalTimeDone + taskTimer.progress), total: Float(totalTimeComputed.getTotal()))
                                .padding(15)
                                .tint(K.Colors.tab)
                                .animation(.easeOut, value: totalTimeDone)
                        }
                        if !task.weekTask{
                            Button{
                                completed = !completed
                            } label: {
                                Image(systemName: completed || totalTimeDone + taskTimer.progress >= totalTimeComputed.getTotal() ?  "checkmark.circle.fill" : "checkmark.circle")
                                    .foregroundColor(K.Colors.tab)
                                    .padding(.trailing, 15)
                            }
                        }
                    }
                    if !task.weekTask{
                        HStack{
                            Spacer()
                            Button{
                                //minus for hours
                                totalTimeComputed.subTime(mins: 60)
                            } label: {
                                Image(systemName: "minus.circle")
                            }
                            Text("\(totalTimeComputed.totalHours) hrs")
                            Button{
                                //add for hours
                                totalTimeComputed.addTime(mins: 60)
                                completed = false
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            Spacer()
                            Button{
                                //minus for mins
                                totalTimeComputed.subTime(mins: 5)
                            } label: {
                                Image(systemName: "minus.circle")
                            }
                            Text("\(totalTimeComputed.totalMins) mins")
                            Button{
                                //add for mins
                                totalTimeComputed.addTime(mins: 5)
                                completed = false
                            } label: {
                                Image(systemName: "plus.circle")
                            }
                            Spacer()
                        }
                        .foregroundColor(K.Colors.text)
                    }
                    
                    Spacer()
                    //MARK: - Finish/Cancel
                    Button("Finish Session"){
                        //if completed is true set task.time to equal task.timeDone
                        if completed {
                            do{
                                print("enter")
                                try realm.write{
                                    task.thaw()?.time = totalTimeComputed.getTotal()
                                }
                            }catch{
                                print("error updating data, \(error)")
                            }
                        }
                        do{
                            try realm.write{
                                task.thaw()?.time = totalTimeComputed.getTotal()
                            }
                        }
                        catch{
                            print("error updating data, \(error)")
                        }
                        updateTimeDone()
                        taskTimer.clearStartTime()
                        dismiss()
                    }
                    .buttonStyle(CustomButton())
                }
                .foregroundColor(K.Colors.text)
                .tint(K.Colors.text)
                .toolbar {
                    ToolbarItem() {
                        Button("Cancel") {
                            //saves progress to realm
                            updateTimeDone()
                            //clears timer
                            taskTimer.clearStartTime()
                            
                            dismiss()
                        }.tint(K.Colors.text)
                    }
                    ToolbarItem(placement: .principal) {
                        Text(task.title)
                            .foregroundColor(K.Colors.text)
                    }
                }
                    
            }
        }
    }
    
    func updateTimeDone() {
        do{
            try realm.write{
                task.thaw()?.timeDone = totalTimeDone + taskTimer.progress
            }
        }catch{
            print("error updating data, \(error)")
        }
    }
    
    func findTask(id: String) -> Task{
        for possTask in tasks {
            if possTask.id.stringValue == id{
                return possTask
            }
        }
        return Task()
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(task: Task(), timeBlock: 10, totalTimeDone: 10)
    }
}
