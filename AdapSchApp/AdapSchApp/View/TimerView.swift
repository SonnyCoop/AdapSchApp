//
//  TimerView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 08/09/2023.
//

import SwiftUI
import RealmSwift

struct TimerView: View {
    let task: Task
    //task.blockLengths in seconds
    @State var timeBlock: Int
    @State var totalTimeDone: Int

    //timer variables
    @State private var timerType: TimerType = .regular
    @State private var paused: Bool = false
    @State private var overtime: Bool = false
    @ObservedObject private var taskTimer: TaskTimer
    
    init(task: Task, timeBlock: Int, totalTimeDone: Int) {
        self.task = task
        _timeBlock = State(initialValue: timeBlock)
        _totalTimeDone = State(initialValue: totalTimeDone)
        self.taskTimer = TaskTimer(sessionBlock: timeBlock)
        self.paused = taskTimer.isPaused()
    }
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                        if completed || totalTimeDone >= task.time {
                            ProgressView(value: 1, total: 1)
                                .padding(.leading, 15)
                                .tint(K.Colors.tab)
                        }
                        else{
                            ProgressView(value: Float(totalTimeDone + taskTimer.progress), total: Float(task.time))
                                .padding(.leading, 15)
                                .tint(K.Colors.tab)
                                .animation(.easeOut, value: totalTimeDone)
                        }
                        Button{
                            completed = !completed
                        } label: {
                            Image(systemName: completed || totalTimeDone + taskTimer.progress >= task.time ?  "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(K.Colors.tab)
                                .padding()
                        }
                        
                        
                    }
                    Spacer()
                    Button("Finish Session"){
                        //if completed is true set task.time to equal task.timeDone
                        if completed {
                            do{
                                try realm.write{
                                    task.thaw()?.time = totalTimeDone
                                }
                            }catch{
                                print("error updating data, \(error)")
                            }
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
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(task: Task(), timeBlock: 10, totalTimeDone: 10)
    }
}
