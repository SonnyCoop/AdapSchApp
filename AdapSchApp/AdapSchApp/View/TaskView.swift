//
//  TaskView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI
import RealmSwift

struct TaskView: View {
    //when true add screen is shown
    @State private var isPresented: Bool = false
    
    let realm = try! Realm()
    @ObservedResults(Category.self) var categories
    
    var body: some View {
        NavigationView{
            ZStack{
                //setting background colour
                K.Colors.background1.ignoresSafeArea()
                VStack{
                    ForEach(categories, id: \.self) { category in
                        ForEach(category.tasks, id: \.self){ task in
                            TaskItemCell(background: Array(category.color), task: task)
                        }
                        .onDelete { task in
                            do{
                                category.tasks.remove(atOffsets: task)
                                try self.realm.write{
                                    realm.delete(category.tasks[task.first!])
                                }
                            }catch{
                                print("error deleting item, \(error)")
                            }
                        }
                    }
                }
                
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

