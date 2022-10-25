//
//  AddTransactionView.swift
//  Greener Test
//
//  Created by Raphaël Payet on 24/10/2022.
//

import SwiftUI
import RealmSwift

struct AddTransactionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.realm) var realm
    
    @ObservedRealmObject var transaction: Transaction
    @State var libelle = ""
    @State var selectedType: TransactionType?
    
    var body: some View {
        VStack(spacing: 10) {
            // Should be in a grid
            ForEach(TransactionType.allCases, id: \.self) { type in
                Button {
                    transaction.type = type
                    selectedType = type
                } label: {
                    CategoryButton(type: type, selectedType: $selectedType)
                }
                .tint(.primary)
            }
            
            TextField("Transaction name", text: $transaction.title)
                .textFieldStyle(.roundedBorder)
            TextField("Description ( optional )", text: $libelle)
                .textFieldStyle(.roundedBorder)
            
            Button {
                saveTransaction()
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
    
    func saveTransaction() {
        try? realm.write({
            if libelle != "" {
                transaction.libelle = libelle
            }
            realm.add(transaction)
        })
        
        dismiss()
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView(transaction: Transaction.transaction1)
            .environment(\.realmConfiguration, Realm.Configuration(inMemoryIdentifier: "previewRealm", schemaVersion: 1))
    }
}
