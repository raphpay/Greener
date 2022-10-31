//
//  TransportImpactViewViewModel.swift
//  Greener
//
//  Created by Raphaël Payet on 31/10/2022.
//

import Foundation

class TransportImpactViewViewModel: ObservableObject {
    @Published var distance: Double = 100
    @Published var transportations: [Transportation] = []
    @Published var showAllTransports = false
    @Published var showCarpool = false
}

extension TransportImpactViewViewModel {
    func updateTransportations() {
        NetworkService.shared.get(for: distance, showAllTransports: showAllTransports, showCarpool: showCarpool) { transportations in
            if let transportations {
                self.sortTransportations(transportations)
            }
        }
    }
    
    func sortTransportations(_ transportationCollection: [Transportation]) {
        DispatchQueue.main.async {
            self.transportations = transportationCollection.sorted(by: { current, next in
                if let currentActualEmissions = current.actualEmissions {
                    if let nextActualEmissions = next.actualEmissions {
                        return currentActualEmissions < nextActualEmissions
                    }
                    return currentActualEmissions < next.emissions.kgco2e
                }
                return current.emissions.kgco2e < next.emissions.kgco2e
            })
        }
    }
    
    func calculateCarpool(for index: Int, action: Action) {
        var transportation = transportations[index]
        guard var actualCarpool = transportation.actualCarpool,
              let maximumCarpool = transportation.carpool else { return }
        
        if action == .plus {
            guard actualCarpool + 1 <= maximumCarpool else { return }
            actualCarpool += 1
        } else if action == .minus {
            guard actualCarpool - 1 > 0 else { return }
            actualCarpool -= 1
        }
        
        transportation.actualCarpool = actualCarpool
        
        transportation.actualEmissions = NetworkService.shared.divideEmissions(by: actualCarpool, sourceEmission: transportation.emissions.kgco2e)
        
        transportations[index] = transportation
    }
}
