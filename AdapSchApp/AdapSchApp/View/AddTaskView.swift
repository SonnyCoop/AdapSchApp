//
//  AddTaskView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI

struct AddTaskView: View {
    //values to be saved
    @State private var title: String = ""
    @State private var hours: Int = 0
    @State private var minutes: Int = 0
    
    var body: some View {
        NavigationView{
            ZStack{
                //background colour
                K.Colors.background1.ignoresSafeArea()
                //the 'form'
                VStack{
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
                    
                    Button("Add") {
                        //add to database
                        print("Title: \($title), Time: \($hours)hr \($minutes)mins")
                    }
                    .buttonStyle(CustomButton())

                    
                }
                .navigationTitle("New Item")
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
