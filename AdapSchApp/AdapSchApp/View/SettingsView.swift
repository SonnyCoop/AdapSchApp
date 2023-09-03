//
//  SettingsView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
            ZStack{
                //setting background colour
                K.Colors.background1.ignoresSafeArea()
                List{
                    //segue to dark more settings
                    NavigationLink("Light/Dark Mode", destination: DarkModeSettings())
                }
            }
            
        }.navigationTitle("Settings")
    }
}


