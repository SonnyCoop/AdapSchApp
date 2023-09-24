//
//  CategoriesView.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 18/09/2023.
//

import SwiftUI
import RealmSwift

struct CategoriesView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedResults(Category.self) var categories
    
    init(){
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(K.Colors.text)]
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                //background colour
                K.Colors.background1.ignoresSafeArea()
                VStack{
                    List{
                        Section{
                            ForEach(categories, id: \.self) { category in
                                if category.title != "No Category"{
                                    Text(category.title)
                                }
                            }
                            .onDelete(perform: deleteRow)
                        }
                        .listRowBackground(K.Colors.background1)
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .navigationBarTitle(Text("Categories"), displayMode: .inline)
            .toolbar {
                ToolbarItem() {
                    Button("Cancel") {
                        //edit code here
                        dismiss()
                    }.tint(K.Colors.text)
                }
            }
        }
    }
    //MARK: - Delete Method
    func deleteRow(at offsets: IndexSet){
        if offsets.first != nil {
            let deletedCategory = categories[offsets.first!]
            print("delete \(deletedCategory.title)")
//            if let indexToDelete = categories.firstIndex(where: {
//                $0 == deletedCategory}) {
//                let indexSet: IndexSet = [indexToDelete]
//                $categories.remove(atOffsets: indexSet)
//            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
