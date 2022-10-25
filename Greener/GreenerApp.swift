//
//  GreenerApp.swift
//  Greener
//
//  Created by Raphaël Payet on 24/10/2022.
//

import SwiftUI

@main
struct GreenerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realmConfiguration, RealmMigrator.configuration)
        }
    }
}
