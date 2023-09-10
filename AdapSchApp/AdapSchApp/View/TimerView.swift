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
    
    @State private var timerType: TimerType = .regular
    @State private var paused: Bool = false
    
    @State private var completed: Bool = false
    
    enum TimerType: String, CaseIterable, Identifiable {
        case regular
        var id: Self { self }
    }
    
    @Environment(\.dismiss) private var dismiss
    
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
                    ZStack{
                        CircularProgressBar(progress: 0.25)
                            .frame(width: 200, height: 200)
                        VStack{
                            Text("Time")
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
                    HStack{
                        if completed || task.timeDone >= task.time {
                            ProgressView(value: 1, total: 1)
                                .padding(.leading, 15)
                                .tint(K.Colors.tab)
                        }
                        else{
                            ProgressView(value: Float(task.timeDone), total: Float(task.time))
                                .padding(.leading, 15)
                                .tint(K.Colors.tab)
                        }
                        Button{
                            completed = !completed
                        } label: {
                            Image(systemName: completed || task.timeDone >= task.time ?  "checkmark.circle.fill" : "checkmark.circle")
                                .foregroundColor(K.Colors.tab)
                                .padding()
                        }
                        
                        
                    }
                    Spacer()
                    Button("Finish Session"){
                        
                    }
                    .buttonStyle(CustomButton())
                }
                .foregroundColor(K.Colors.text)
                .tint(K.Colors.text)
                .toolbar {
                    ToolbarItem() {
                        Button("Cancel") {
                            //edit code here
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
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(task: Task())
    }
}
