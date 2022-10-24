//
//  AddTransactionView.swift
//  Greener Test
//
//  Created by Raphaël Payet on 24/10/2022.
//

import SwiftUI

struct AddTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var transactions: [Transaction]
    
    @State private var selectedType: Transaction.TransactionType?
    @State private var title: String = ""
    @State private var description: String = ""
    
    var body: some View {
        VStack(spacing: 10) {
            // Should be in a grid
            ForEach(Transaction.TransactionType.allCases, id: \.self) { type in
                Button {
                    selectedType = type
                } label: {
                    CategoryButton(type: type, selectedType: $selectedType)
                }
                .tint(.primary)
            }
            
            TextField("Transaction name", text: $title)
                .textFieldStyle(.roundedBorder)
            TextField("Description ( optionnal )", text: $description)
                .textFieldStyle(.roundedBorder)
            
            Button {
                // Save the transaction
                let transaction = Transaction(title: title, description: description, type: selectedType)
                transactions.append(transaction)
                dismiss()
            } label: {
                Text("Add the transaction")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .tint(.primary)

            Spacer()
        }
        .padding()
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(transactions: .constant([]))
    }
}
