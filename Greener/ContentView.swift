//
//  ContentView.swift
//  Greener Test
//
//  Created by Raphaël Payet on 24/10/2022.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @ObservedResults(Transaction.self) var transactions
    
    @State private var showSheet = false
    
    var body: some View {
        ZStack {
            plusButton
            
            VStack {
                ForEach(transactions) { transaction in
                    HStack {
                        Text(transaction.type.emoji)
                        Text(transaction.title)
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $showSheet) {
            AddTransactionView(transaction: Transaction())
        }
    }
    
    var plusButton: some View {
        VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Spacer()
                
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                }
                .frame(width: 50, height: 50)
            }
        }
    }
}

// TODO: Find how to use previews with mocked Realm data
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(transactions: )
//    }
//}
//
