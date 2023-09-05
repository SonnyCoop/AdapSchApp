//
//  FormHiddenBackground.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 05/09/2023.
//

import Foundation
import SwiftUI

struct FormHiddenBackground: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content.onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .systemGroupedBackground
            }
        }
    }
}
