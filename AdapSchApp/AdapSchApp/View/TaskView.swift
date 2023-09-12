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
        case parentCategory, dueDate, progress, individualTask
        var id: Self { self }
    }
    
    //MARK: - Sorting Methods
    var sortedTasks: [Task] {
        switch sortingChoice {
        case .parentCategory:
            return tasks.sorted { ($0.parentCategory.first?.color[0])! < ($1.parentCategory.first?.color[0])!}
        case .dueDate:
            return (tasks.sorted { (!$0.weekTask && $1.weekTask) || ($0.weekTask && !$1.weekTask) }).sorted { ($0.dueDate < $1.dueDate) || $1.weekTask  }
        case .progress:
            return tasks.sorted { !($0.time == 0 ? false : ($1.time == 0 ? true : ($0.timeDone / $0.time) > $1.timeDone / $1.time)) }
        case .individualTask:
            return tasks.sorted { (!$0.weekTask && $1.weekTask) || ($0.weekTask && !$1.weekTask) }
        }
    }
    
    //realm setup
    let realm = try! Realm()
    @ObservedResults(Task.self) var tasks
    
    
    var body: some View {
        NavigationView{
            ZStack{
                //setting background colour
                K.Colors.background1.ignoresSafeArea()
                //adding all the items
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
                        //picking sorting option
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Picker("Sort By:", selection: $sortingChoice){
                                Text("Category").tag(SortingChoice.parentCategory)
                                Text("Due Date").tag(SortingChoice.dueDate)
                                Text("Progress").tag(SortingChoice.progress)
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
            //when true addTaskView appears from the bottom layed over the top
            .sheet(isPresented: $isPresented, content: {
                AddTaskView()
            })
            
        }
    }
    
    //MARK: - Delete Method
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

    //gets the category colours so they can be used for the background of the boxes
    func getBackground(task: Task) -> [String]{
        let category = task.parentCategory
        if let colors = category.first?.color {
            return Array(colors)
        }
        return ["#ffffff","#ffffff"]
    }
}

