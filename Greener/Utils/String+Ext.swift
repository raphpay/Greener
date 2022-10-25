//
//  String+Ext.swift
//  Greener Test
//
//  Created by Raphaël Payet on 24/10/2022.
//

import Foundation

extension String {
    var firstLetter: String {
        return "\(self.prefix(1))"
    }
    
    func capitalizingFirstLetter() -> String {
        return self.firstLetter.uppercased() + self.lowercased().dropFirst()
    }
}
