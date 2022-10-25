//
//  Transaction.swift
//  Greener
//
//  Created by Raphaël Payet on 24/10/2022.
//

import Foundation
import RealmSwift

class Transaction: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String
    @Persisted var libelle: String?
    @Persisted var type: TransactionType
}

enum TransactionType: String, CaseIterable, PersistableEnum {
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


