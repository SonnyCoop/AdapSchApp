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
    @State var timeRemaining: Int
    @State var totalTimeDone: Int

    //timer variables
    @State private var timerType: TimerType = .regular
    @State private var paused: Bool = false
    @State private var overtime: Bool = false
//    @State private var timeStarted
    
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
                        CircularProgressBar(progress: !overtime ? (Double(timeRemaining) / Double(task.blockLenghts * 60)) : 0)
                            .frame(width: 200, height: 200)
                        VStack{
                            Text(timeFormatter())
                                .onReceive(timer, perform: { _ in
                                    if overtime && !paused {
                                        timeRemaining += 1
                                    }
                                    else if timeRemaining > 0 && !paused {
                                        timeRemaining -= 1
                                    }
                                    else if timeRemaining == 0 && !paused {
                                        overtime = true
                                        timeRemaining += 1
                                    }
                                    
                                    if timeRemaining % 60 == 0 {
                                        totalTimeDone += 1
                                    }
                                })
                                .padding()
                            Button{
                                paused = !paused
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
                            ProgressView(value: Float(totalTimeDone), total: Float(task.time))
                                .padding(.leading, 15)
                                .tint(K.Colors.tab)
                                .animation(.easeOut, value: totalTimeDone)
                        }
                        Button{
                            completed = !completed
                        } label: {
                            Image(systemName: completed || totalTimeDone >= task.time ?  "checkmark.circle.fill" : "checkmark.circle")
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
                        dismiss()
                    }
                    .buttonStyle(CustomButton())
                }
                .foregroundColor(K.Colors.text)
                .tint(K.Colors.text)
                .toolbar {
                    ToolbarItem() {
                        Button("Cancel") {
                            //edit code here
                            updateTimeDone()
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
    func timeFormatter() -> String{
        //formatting the date
        let totalHrs = timeRemaining / 3600
        var totalSecs = timeRemaining % 3600
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
    
    func updateTimeDone() {
        do{
            try realm.write{
                task.thaw()?.timeDone = totalTimeDone
            }
        }catch{
            print("error updating data, \(error)")
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(task: Task(), timeRemaining: 10, totalTimeDone: 10)
    }
}
