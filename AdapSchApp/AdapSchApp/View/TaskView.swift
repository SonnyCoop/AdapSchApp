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
    @State private var sortingChoice: SortingChoice = .parentCategory
    
    enum SortingChoice: String, CaseIterable, Identifiable {
        case parentCategory, dueDate, progress, completed, individualTask
        var id: Self { self }
    }
    
    var sortedTasks: [Task] {
        switch sortingChoice {
        case .parentCategory:
            return tasks.sorted { ($0.parentCategory.first?.color[0])! < ($1.parentCategory.first?.color[0])!}
        case .dueDate:
            return tasks.sorted { ($0.dueDate < $1.dueDate) || (!$0.weekTask && $1.weekTask) }
        case .progress:
            return tasks.sorted { $0.time == 0 ? false : ($1.time == 0 ? true : ($0.timeDone / $0.time) > $1.timeDone / $1.time) }
        case .completed:
            return tasks.sorted { ($0.timeDone > $0.time) && !($1.timeDone > $1.time)}
        case .individualTask:
            return tasks.sorted { !$0.weekTask && $1.weekTask}
        }
    }
    
    let realm = try! Realm()
    @ObservedResults(Task.self) var tasks
    
    var body: some View {
        NavigationView{
            ZStack{
                //setting background colour
                K.Colors.background1.ignoresSafeArea()
                List{
                    Section{
                        ForEach(sortedTasks, id: \.self) { task in
                            TaskItemCell(task: task, background: getBackground(task: task))
                        }
                        .onDelete(perform: deleteRow)
                    }
                    .listRowBackground(K.Colors.background1)
                    .listRowSeparator(.hidden)
                }
                .modifier(FormHiddenBackground())
                .listStyle(.plain)
                
                //MARK: - Navigation Tab Setup
                    .toolbarBackground(K.Colors.tab, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Edit") {
                                //edit code here
                            }.tint(K.Colors.text)
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Picker("Sort By:", selection: $sortingChoice){
                                Text("Category").tag(SortingChoice.parentCategory)
                                Text("Due Date").tag(SortingChoice.dueDate)
                                Text("Progress").tag(SortingChoice.progress)
                                Text("Completed").tag(SortingChoice.completed)
                                Text("Individual Task").tag(SortingChoice.individualTask)
                            }
                            .tint(K.Colors.text)
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
    
    func deleteRow(at offsets: IndexSet){
        if offsets.first != nil {
            let deletedTask = sortedTasks[offsets.first!]
            if let indexToDelete = tasks.firstIndex(where: {
                $0 == deletedTask}) {
                let indexSet: IndexSet = [indexToDelete]
                $tasks.remove(atOffsets: indexSet)
            }
                
        }
        
    }

    func getBackground(task: Task) -> [String]{
        //this is causing an error
        let category = task.parentCategory
        if let colors = category.first?.color {
            return Array(colors)
        }
        return ["#ffffff","#ffffff"]
    }
}

