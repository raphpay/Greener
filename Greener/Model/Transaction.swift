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


extension Transaction {
    static let transaction1 = Transaction(value: ["title": "Car trip", "libelle": "Vacances au Ventoux", "type": "transport"])
    static let transaction2 = Transaction(value: ["title": "Restaurant", "libelle": "Repas avec viande", "type": "food"])
    static let transaction3 = Transaction(value: ["title": "Phone", "libelle": "Achat téléphone neuf", "type": "digital"])
    
    static let transactionArray = [transaction1, transaction2, transaction3]

    static var previewRealm: Realm {
      get {
         var realm: Realm
         let identifier = "previewRealm"
         let config = Realm.Configuration(inMemoryIdentifier: identifier)
         do {
            realm = try Realm(configuration: config)
             try? realm.write {
                 realm.add(Transaction.transaction1)
                 realm.add(Transaction.transaction2)
                 realm.add(Transaction.transaction3)
             }
            return realm
         } catch let error {
            fatalError("Error: \(error.localizedDescription)")
         }
      }
   }
}