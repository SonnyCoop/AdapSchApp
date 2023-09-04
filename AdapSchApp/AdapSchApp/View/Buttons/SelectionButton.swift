//
//  SelectionButton.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 04/09/2023.
//

import SwiftUI

struct SelectionButton: ButtonStyle {
    @State var isSelected: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isSelected ? K.Colors.tab : K.Colors.background1)
            .foregroundStyle(K.Colors.text)
            .cornerRadius(25)
            .overlay(RoundedRectangle(cornerRadius: 25).stroke(K.Colors.background2, lineWidth: 2))
    }
}

