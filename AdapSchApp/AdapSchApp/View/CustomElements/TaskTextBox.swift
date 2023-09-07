//
//  TaskTextBox.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 07/09/2023.
//

import SwiftUI

struct TaskTextBox: ViewModifier {
    let background: [String]
    @Environment(\.colorScheme) var darkMode
    func body(content: Content) -> some View {
        content
            .background(RoundedRectangle(cornerRadius: 20).fill(darkMode == .light ? Color(UIColor(hex: background[0]) ?? .red) : Color(UIColor(hex: background[1]) ?? .red)))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 100)

    }
}
