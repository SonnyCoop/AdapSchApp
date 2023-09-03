//
//  DarkModeSettings.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI

struct DarkModeSettings: View {
    
    //use user defaults to save preference
    //page not done feel free to change anything and everything
    
    var body: some View {
        ZStack{
            K.Colors.background1.ignoresSafeArea()
            HStack{
                Button{
                    //code
                } label:{
                    Label("Auto", systemImage: "checkmark.circle.fill")
                }
                Button{
                    //code
                } label:{
                    Label("Light", systemImage: "checkmark.circle")
                }
                Button{
                    //code
                } label:{
                    Label("Dark", systemImage: "checkmark.circle")
                }
            }
        }
    }
}
