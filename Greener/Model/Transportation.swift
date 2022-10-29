//
//  Transportation.swift
//  Greener
//
//  Created by Raphaël Payet on 25/10/2022.
//

import Foundation

struct Transportation: Codable, Identifiable {
    var id: Int
    let name: String
    var emissions: Emissions
    let source: String?
    let emoji: Emoji?
    let description: String?
    let carpool: Int?
    let display: Display?
    var isDuplicated: Bool? = false
    
    var type: TransportationType? {
        switch id {
        case 1:
            return .plane
        case 2:
            return .tgv
        case 3:
            return .intercite
        case 4:
            return .carThermal
        case 5:
            return .carElectric
        case 6:
            return .autocar
        case 7:
            return .walkOrBike
        case 8:
            return .bikeOrElectricScooter
        case 9:
            return .busThermal
        case 10:
            return .tramway
        case 11:
            return .metro
        case 12:
            return .scooterOrBike
        case 13:
            return .bike
        case 14:
            return .rer
        case 15:
            return .ter
        case 16:
            return .busElectric
        case 21:
            return .busGNV
        default:
            return nil
        }
    }
    
    var maximumCarpool: Int? {
        switch type {
        case .bike:
            return 2
        case .carThermal:
            return 5
        case .carElectric:
            return 5
        default: return 0
        }
    }
    
    enum TransportationType: String, Codable {
        case plane, tgv, intercite, carThermal, carElectric
        case autocar, walkOrBike, bikeOrElectricScooter, busThermal, tramway
        case metro, scooterOrBike, bike, rer, ter
        case busElectric, busGNV
    }
}

struct Emissions: Codable {
    var kgco2e: Double
}

struct Emoji: Codable {
    let main: String
    let secondary: String?
}

struct Display: Codable {
    let min: Double?
    let max: Double?
}
