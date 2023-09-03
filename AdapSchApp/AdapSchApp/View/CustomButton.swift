//
//  CustomButton.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import SwiftUI

struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(K.Colors.tab)
            .foregroundStyle(K.Colors.text)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

