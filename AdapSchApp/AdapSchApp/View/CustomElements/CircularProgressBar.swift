//
//  CircularProgressBar.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 10/09/2023.
//

import SwiftUI

struct CircularProgressBar: View {
    let progress: Double
    
    var body: some View {
        ZStack { // 1
            Circle()
                .stroke(
                    K.Colors.text,
                    lineWidth: 20
                )
            Circle() // 2
                .trim(from: 0, to: progress)
                .stroke(
                    K.Colors.tab,
                    style: StrokeStyle(
                        lineWidth: 20,
                        lineCap: .round
                        )
                    
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(progress: 0.5)
    }
}
