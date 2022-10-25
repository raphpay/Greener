//
//  ContentView.swift
//  Greener Test
//
//  Created by Raphaël Payet on 24/10/2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet = false
    @State var transactions = [Transaction]()
    
    var body: some View {
        ZStack {
            plusButton
            
            VStack {
                ForEach(transactions, id: \.self) { transaction in
                    HStack {
                        Text(transaction.type?.emoji ?? "")
                        Text(transaction.title)
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $showSheet) {
            AddTransactionView(transactions: $transactions)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(transactions: Transaction.mockData)
    }
}
