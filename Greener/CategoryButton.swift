//
//  CategoryButton.swift
//  Greener
//
//  Created by Raphaël Payet on 24/10/2022.
//

import SwiftUI

struct CategoryButton: View {
    
    let type: Transaction.TransactionType
    @Binding var selectedType: Transaction.TransactionType?
    
    var body: some View {
        HStack {
            Text(type.rawValue.capitalizingFirstLetter())
                .font(.headline)
            Text(type.emoji)
        }
        .padding()
        .background(selectedType == type ? Color.blue : Color.gray) // Should be a lighter gray
        .cornerRadius(10)
    }
}


struct CategoryButton_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButton(type: .digital, selectedType: .constant(.digital))
    }
}
