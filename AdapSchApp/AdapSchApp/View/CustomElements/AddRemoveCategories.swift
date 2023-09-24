//
//  AddRemoveCategories.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 18/09/2023.
//

import SwiftUI

struct AddRemoveCategories: View {
    
    @State private var isPresented: Bool = false
    
    var body: some View {
        HStack{
            VStack{
                Text("Add/Remove Categories")
                            .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.leading, 10)
        
        }
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(K.Colors.background2)
                .frame(height: 40))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .foregroundColor(K.Colors.text)
            .fixedSize(horizontal: false, vertical: true)
            //shows timer
            .onTapGesture {
                isPresented = true
            }
            
            //when true timer slides up
            .sheet(isPresented: $isPresented, content: {
                CategoriesView()
                    .interactiveDismissDisabled()
            })
    }
}

struct AddRemoveCategories_Previews: PreviewProvider {
    static var previews: some View {
        AddRemoveCategories()
    }
}
