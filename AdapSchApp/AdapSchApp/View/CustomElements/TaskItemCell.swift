//
//  TaskItemCell.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 08/09/2023.
//

import SwiftUI
import RealmSwift

struct TaskItemCell: View {
    let task: Task
    
    let background: [String]
    
    
    //when true add screen is shown
    @State private var isPresented: Bool = false
    @Environment(\.colorScheme) var darkMode
    
    let realm = try! Realm()
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(task.title)
                if !task.weekTask{
                    Text("due \(dateFormatter.string(from: task.dueDate))")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            ProgressView(value: Float(task.timeDone), total: Float(task.time)) //error maker
                .frame(maxHeight: .infinity)
                .padding()
        }
        .background(RoundedRectangle(cornerRadius: 10)
            .fill(darkMode == .light ? Color(UIColor(hex: background[0]) ?? .red) : Color(UIColor(hex: background[1]) ?? .red))
            .frame(height: 70))
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding()
        .foregroundColor(K.Colors.text)
        .fixedSize(horizontal: false, vertical: true)
        
        .onTapGesture {
            isPresented = true
        }
        
        //when true addTaskView slides up -- will crash if done a second time dues to bool already being true
        .sheet(isPresented: $isPresented, content: {
            TimerView(task: task)
        })
    }
}

struct TaskItemCell_Previews: PreviewProvider {
    static var previews: some View {
        TaskItemCell(task: Task(), background: ["00ff00", "38ff89"])
    }
}
