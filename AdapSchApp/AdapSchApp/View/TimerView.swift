//
//  TimerView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 08/09/2023.
//

import SwiftUI
import RealmSwift

struct TimerView: View {
    let task: Task
    var body: some View {
        Text("\(task.title) Timer View")
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(task: Task())
    }
}
