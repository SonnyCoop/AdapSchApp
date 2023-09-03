//
//  TaskView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI

struct TaskView: View {
    //when true add screen is shown
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                //setting background colour
                K.Colors.background1.ignoresSafeArea()
                
                Text("Tasks")
                
                //MARK: - Navigation Tab Setup
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
            //when true addTaskView appears from the bottom layed over the top --  will crash on second run due to still being true
            .sheet(isPresented: $isPresented, content: {
                AddTaskView()
            })
        }
    }
}

