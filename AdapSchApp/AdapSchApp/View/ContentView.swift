//
//  ContentView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI

struct ContentView: View {
    init(){
        UITabBar.appearance().backgroundColor = UIColor(K.Colors.tab)
        UITabBar.appearance().unselectedItemTintColor = UIColor(K.Colors.text)
    }
    @State private var selection: Tab = .calendar
    
    enum Tab {
        case calendar
        case tasks
        case settings
    }
    var body: some View {
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
        .accentColor(K.Colors.background2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
