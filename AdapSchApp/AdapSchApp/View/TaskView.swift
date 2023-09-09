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
//    @State private var taskArray: Results<Task>
    
    let realm = try! Realm()
    @ObservedResults(Task.self) var tasks
    
//    init(){
//        for category in categories {
////            taskArray.append(contentsOf: category.tasks)
//            taskArray.
//        }
//    }
    
    var body: some View {
        NavigationView{
            ZStack{
                //setting background colour
                K.Colors.background1.ignoresSafeArea()
                VStack{
                    ForEach(tasks, id: \.self) { task in
                        TaskItemCell(task: task, background: getBackground(task: task))
                    }
                    
//                    ForEach(categories, id: \.self) { category in
////                        taskList = category.tasks
//                        ForEach(category.tasks, id: \.self){ task in
//                            TaskItemCell(background: Array(category.color), task: task)
//                        }
//                        .onDelete(perform: $categories.tasks.remove(atOffsets: task))
                        
//                        .onDelete { task in
//                            do{
//                                category.tasks.remove(atOffsets: task)
//                                try self.realm.write{
//                                    realm.delete(category.tasks[task.first!])
//                                }
//                            }catch{
//                                print("error deleting item, \(error)")
//                            }
//                        }
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

    func getBackground(task: Task) -> [String]{
        //this is causing an error
        let category = task.parentCategory
        if let colors = category.first?.color {
            print(colors)
            return Array(colors)
        }
        return ["#ffffff","#ffffff"]
    }
}

