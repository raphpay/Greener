//
//  Double+Ext.swift
//  Greener
//
//  Created by Raphaël Payet on 26/10/2022.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(to places: Int) -> String {
        return String(format: "%.\(places)f", self)
    }

    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
