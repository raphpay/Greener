//
//  RealmMigrator.swift
//  Greener
//
//  Created by Raphaël Payet on 25/10/2022.
//

import RealmSwift

enum RealmMigrator {
    static private func migrationBlock(migration: Migration, oldSchemaVersion: UInt64) {
        if oldSchemaVersion < 1 {
            migration.enumerateObjects(ofType: Transaction.className()) { _, newObject in
                newObject?["libelle"] = nil
            }
        }
    }
    
    static var configuration: Realm.Configuration {
      Realm.Configuration(schemaVersion: 1, migrationBlock: migrationBlock)
    }
}

