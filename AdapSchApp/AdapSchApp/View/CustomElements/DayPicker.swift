//
//  DayPicker.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 06/09/2023.
//

import Foundation
import SwiftUI


struct DayPicker: View {
    @State private var selectedDays: [Day] = []
    
    enum Day: String, CaseIterable {
        case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
    }
    
    var body: some View {
        HStack {
            ForEach(Day.allCases, id: \.self) { day in
                Text(String(day.rawValue.prefix(3)))
                    .bold()
                    .foregroundColor(K.Colors.text)
                    .frame(maxWidth: .infinity, maxHeight: 35)
                    .background(selectedDays.contains(day) ? K.Colors.tab.cornerRadius(10): K.Colors.background2.cornerRadius(10))
                    .onTapGesture {
                        if selectedDays.contains(day) {
                            selectedDays.removeAll(where: {$0 == day})
                        }
                        else {
                            selectedDays.append(day)
                        }
                    }
            }
        }
    }
    
    func getDays() -> [String] {
        var dayList = [String]()
        for day in Day.allCases {
            dayList.append(day.rawValue)
        }
        return dayList
    }
}
