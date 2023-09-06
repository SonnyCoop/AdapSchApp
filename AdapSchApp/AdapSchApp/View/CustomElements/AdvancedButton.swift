//
//  advancedButton.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 06/09/2023.
//

import SwiftUI

struct AdvancedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(K.Colors.background1)
            .foregroundStyle(K.Colors.text)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(K.Colors.background2, lineWidth: 1))
            .frame(maxWidth: .infinity)
    }
}

