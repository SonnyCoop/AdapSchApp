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
    
    //variables for checking whether a timer is present
    @State private var timerIsPresented: Bool = false
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("TimesSaved.plist")
    
    //upon creation set the tab bar to the appropriate colours
    init(){
        UITabBar.appearance().backgroundColor = UIColor(K.Colors.tab)
        UITabBar.appearance().unselectedItemTintColor = UIColor(K.Colors.text)
        UITabBar.appearance().barTintColor = UIColor(K.Colors.tab)
        refreshWeeklyTasks()
        _timerIsPresented = State(initialValue: refreshTimers())
    }
    
    //set the default screen to calendar
    @State private var selection: Tab = .calendar
    
    //options for the tab
    enum Tab {
        case calendar
        case tasks
        case settings
    }
    var body: some View {
        
        //MARK: - TabView Code
        TabView(selection: $selection) {
            CalendarView()
                .tabItem{
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(Tab.calendar)
            
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
        .sheet(isPresented: $timerIsPresented, content: {
            TimerView()
                .interactiveDismissDisabled()
        })
        
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
    
    func refreshTimers() -> Bool{
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                let dataRetrived = try decoder.decode(TimeSaved.self, from: data)
                if dataRetrived.startTime != nil{
                    return true
                }
            }catch{
                print("error decoding item array, \(error)")
            }
        }
        else{
            print("here")
        }
        return false
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
