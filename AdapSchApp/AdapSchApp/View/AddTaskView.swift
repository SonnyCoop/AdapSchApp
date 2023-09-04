//
//  AddTaskView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI
import RealmSwift

struct AddTaskView: View {
    //values to be saved
    @State private var title: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    @State private var selectedScreen = "daily"
    
    @ObservedResults(Task.self) var tasks
    
    @Environment(\.dismiss) private var dismiss
    
    private let screens = ["daily", "weekly", "downtime"]
    
    var body: some View {
        NavigationView{
            ZStack{
                //background colour
                K.Colors.background1.ignoresSafeArea()
                VStack{
                    //display buttons
                    HStack{
                        ForEach(screens, id: \.self){ screen in
                            Text(screen)
                                .padding()
                                .background(selectedScreen == screen ? K.Colors.tab : K.Colors.background1)
                                .foregroundStyle(K.Colors.text)
                                .cornerRadius(25)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(K.Colors.background2, lineWidth: 2))
                                .onTapGesture {
                                    selectedScreen = screen
                                }
                            
                        }
                    }
                    //MARK: - Daily display
                    if selectedScreen == "daily"{
                        HStack{
                            Text("Title:")
                            TextField("Enter title", text: $title)
                        }
                        
                        Text("Estimated Time")
                        HStack{
                            Picker("Estimated Time", selection: $hours){
                                ForEach(0...30, id:\.self){
                                    number in
                                    Text("\(number)")
                                }
                            }.pickerStyle(.wheel)
                            Text("hours")
                            Picker("Estimated Time", selection: $minutes){
                                ForEach((0...11).map {$0 * 5}, id:\.self){
                                    number in
                                    Text("\(number)")
                                }
                            }.pickerStyle(.wheel)
                            Text("mins")
                        }
                    }
                    //MARK: - Weekly Display
                    else if selectedScreen == "weekly"{
                        Text("Weekly stuff")
                    }
                    //MARK: - Downtime Display
                    else{
                        Text("Downtime stuff")
                    }
                    
                    Spacer()
                    Button("Add") {
                        //add to database
                        print("Title: \($title), Time: \($hours)hr \($minutes)mins")
                        
                        //creating task record
                        let task = Task()
                        task.title = title
                        task.time = hours * 60 + minutes
                        
                        $tasks.append(task)
                        
                        //closes window
                        dismiss()
                    }
                    .buttonStyle(CustomButton())

                    
                }
                .toolbar {
                    ToolbarItem() {
                        Button("Cancel") {
                            //edit code here
                            dismiss()
                        }.tint(K.Colors.text)
                    }
                }
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
