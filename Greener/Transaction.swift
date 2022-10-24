//
//  Transaction.swift
//  Greener
//
//  Created by Raphaël Payet on 24/10/2022.
//

import Foundation

struct Transaction: Hashable {
    var title: String
    var description: String?
    var type: TransactionType?
    
    enum TransactionType: String, CaseIterable {
        case transport, housing, food, digital, various
        
        var emoji: String {
            switch self {
                case .transport:
                    return "🚗"
                case .housing:
                    return "🏡"
                case .food:
                    return "🍽"
                case .digital:
                    return "📱"
                case .various:
                    return "📦"
            }
        }
    }
    
    static let mockData = [
        Transaction(title: "Car", type: .transport),
        Transaction(title: "Grocery", type: .food),
        Transaction(title: "New phone", type: .digital)
    ]
}
