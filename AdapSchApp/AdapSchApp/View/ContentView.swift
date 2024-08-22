//
//  ContentView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    let realm = try! Realm()
    @ObservedResults(Task.self) var tasks
    
    //upon creation set the tab bar to the appropriate colours
    init(){
        UITabBar.appearance().backgroundColor = UIColor(K.Colors.tab)
        UITabBar.appearance().unselectedItemTintColor = UIColor(K.Colors.text)
        UITabBar.appearance().barTintColor = UIColor(K.Colors.tab)
        clearTimers()
        refreshWeeklyTasks()
    }
    
    //set the default screen to calendar
    @State private var selection: Tab = .tasks
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TimesSaved.plist")
    
    //options for the tab
    enum Tab {
//        case calendar
        case tasks
        case settings
    }
    var body: some View {
        
        //MARK: - TabView Code
        TabView(selection: $selection) {
//            CalendarView()
//                .tabItem{
//                    Label("Calendar", systemImage: "calendar")
//                }
//                .tag(Tab.calendar)
            
            TaskView()
                .tabItem{
                    Label("Tasks", systemImage: "checklist")
                }
                .tag(Tab.tasks)
            
            SettingsView()
                .tabItem{
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(Tab.settings)
        }
        .accentColor(K.Colors.background2) //colour for selected
        
    }
    
    func clearTimers(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(TimeSaved(startTime: nil))
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding item array, \(error)")
        }
    }
    
    func refreshWeeklyTasks(){
        for task in tasks {
            if task.weekTask && task.dueDate < Date() {
                do{
                    try realm.write{
                        task.dueDate = Date.today().next(.monday)
                        task.timeDone = 0
                    }
                }catch{
                    print("error updating data, \(error)")
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
