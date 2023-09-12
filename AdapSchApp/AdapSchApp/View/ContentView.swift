//
//  ContentView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI

struct ContentView: View {
    //upon creation set the tab bar to the appropriate colours
    init(){
        UITabBar.appearance().backgroundColor = UIColor(K.Colors.tab)
        UITabBar.appearance().unselectedItemTintColor = UIColor(K.Colors.text)
        UITabBar.appearance().barTintColor = UIColor(K.Colors.tab)
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
        
    }
    
}

//#if canImport(UIKit)
//extension View {
//    func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//#endif

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
