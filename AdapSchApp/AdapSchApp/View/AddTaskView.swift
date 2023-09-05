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
    @State private var dueDate = Date()
    @State private var selectedScreen = "daily"
    @State private var showingAlert = false
    @State private var category = "No Category"
    @State private var newCategory = ""

    //setting up realm
    let realm = try! Realm()
    @ObservedResults(Category.self) var categories
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
                            var title: String {
                                switch screen {
                                case "daily" :
                                    return "Daily \n Task"
                                case "weekly" :
                                    return "Weekly \n Task"
                                default:
                                    return "Downtime"
                                }
                            }
                            Text(title)
                                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                                .frame(maxWidth: . infinity, maxHeight: .infinity)
                                .multilineTextAlignment(.center)
                                .background(selectedScreen == screen ? K.Colors.tab : K.Colors.background1)
                                .foregroundStyle(K.Colors.text)
                                .cornerRadius(25)
                                .overlay(RoundedRectangle(cornerRadius: 25).stroke(K.Colors.background2, lineWidth: 2))
                                .onTapGesture {
                                    selectedScreen = screen
                                }
                            
                        }
                    }.frame(maxHeight: 80)
                    //MARK: - Daily display
                    if selectedScreen == "daily"{
                        Form{
                            HStack{
                                Text("Title:")
                                TextField("Enter title", text: $title)
                                    .foregroundColor(K.Colors.text)
                                    .textInputAutocapitalization(.words)
                            }
                            //category picker
                            HStack{
                                Picker("Category:", selection: $category){
                                    Text("No Category")
                                        .tag("No Category")
                                    ForEach(categories){ //line giving issues in view mode
                                        cat in
                                        Text("\(cat.title)")
                                            .tag(cat.title)
                                    }
                                    Text("Add Category +")
                                        .tag("add category")
                                }.onChange(of: category, perform: { newValue in
                                    if newValue == "add category"{
                                        showingAlert = true
                                    }
                                })
                            }
                            VStack{
                                Text("Estimated Time")
                                HStack{
                                    Picker("Estimated Time", selection: $hours){
                                        ForEach(0...30, id:\.self){
                                            number in
                                            Text("\(number)")
                                                .foregroundColor(K.Colors.text)
                                        }
                                    }.pickerStyle(.wheel)
                                    Text("hours")
                                    Picker("Estimated Time", selection: $minutes){
                                        ForEach((0...11).map {$0 * 5}, id:\.self){
                                            number in
                                            Text("\(number)")
                                                .foregroundColor(K.Colors.text)
                                        }
                                    }.pickerStyle(.wheel)
                                    Text("mins")
                                }
                            }
                            VStack{
                                DatePicker("Due Date", selection: $dueDate,
                                           displayedComponents: [.date])
                            }


                        }.modifier(FormHiddenBackground())
                        .foregroundColor(K.Colors.text)
                        .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})

                        Spacer()
                        Button("Add") {
                            //creating task record
                            let task = Task()
                            task.title = title
                            task.time = hours * 60 + minutes
                            task.dueDate = dueDate
                            let selectCat = realm.object(ofType: Category.self, forPrimaryKey: category)
                            
                            //add to database
                            do{
                                try realm.write {
                                    selectCat?.tasks.append(task)
                                }
                            }catch{
                                print("error updating data, \(error)")
                            }
                            
                            //closes window
                            dismiss()
                        }
                        .buttonStyle(CustomButton())
                    }
                    //MARK: - Weekly Display
                    else if selectedScreen == "weekly"{
                        Text("Weekly stuff")
                        Spacer()
                    }
                    //MARK: - Downtime Display
                    else{
                        Text("Downtime stuff")
                        Spacer()
                    }
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
        //MARK: - adding new categories
        .alert("Add Category", isPresented: $showingAlert) {
            TextField("Category", text: $newCategory)
                .textInputAutocapitalization(.words)
            HStack{
                Button("Cancel", action: {
                    category = "No Category"
                    showingAlert = false})
                Button("Add", action: addCategory)
            }
        }
    }
    
    //MARK: - Add category
    func addCategory(){
        let versionPresent = realm.object(ofType: Category.self, forPrimaryKey: newCategory)
        if newCategory != "" && versionPresent == nil{
            let newCat = Category()
            newCat.title = newCategory
            newCat.totalTime = 0
            newCat.color.append(K.categoryBoxColors[categories.count].0)
            newCat.color.append(K.categoryBoxColors[categories.count].1)
            
            $categories.append(newCat)
            
            category = newCategory
        }
        else{
            category = "No Category"
        }
        newCategory = ""
    }
}

struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
            
    }
}
