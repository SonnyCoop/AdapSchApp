//
//  ContentView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI

struct CalendarView: View {
    //when changed addTaskView is presented
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                //sets background colour
                K.Colors.background1.ignoresSafeArea()
                Text("Calender")
                //MARK: - Navigation Bar Setup
                    .toolbarBackground(K.Colors.tab, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Edit") {
                                //edit code here
                            }.tint(K.Colors.text)
                        }
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button{
                                isPresented = true
                            } label: {
                                Label("Add", systemImage: "plus")
                            }.tint(K.Colors.text)
                        }
                    }
            }
            //when true addTaskView slides up -- will crash if done a second time dues to bool already being true
            .sheet(isPresented: $isPresented, content: {
                AddTaskView()
            })
        }
    }
        
}


