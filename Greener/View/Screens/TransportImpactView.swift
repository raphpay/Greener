//
//  TransportImpactView.swift
//  Greener
//
//  Created by Raphaël Payet on 26/10/2022.
//

import SwiftUI

struct TransportImpactView: View {
    
    @State private var distance: Double = 100
    @State private var transportations: [Transportation] = []
    @State private var showAllTransports = false
    @State private var showCarpool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                slider
                
                buttons
                
                list
            }
            .navigationTitle("Impact du transport")
        }
    }
    
    var slider: some View {
        VStack {
            Text("Distance: \(distance.rounded(to: 2))")
            
            HStack {
                Button {
                    if distance - 10 > 0 {
                        distance -= 10
                    }
                    updateTransportations()
                } label: {
                    Image(systemName: "minus.circle")
                }

                Slider(value: $distance, in: 0...1000) { editing in
                    if !editing {
                        updateTransportations()
                    }
                }
                
                Button {
                    if distance + 10 < 1000 {
                        distance += 10
                    }
                    updateTransportations()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .padding()
    }
    
    var buttons: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Button {
                showAllTransports.toggle()
                updateTransportations()
            } label: {
                Image(systemName: showAllTransports ? "checkmark.rectangle.fill" : "rectangle")
                Text("Afficher tous les modes de transport")
                    .foregroundColor(.primary)
            }
            
            Button {
                showCarpool.toggle()
                updateTransportations()
            } label: {
                Image(systemName: showCarpool ? "checkmark.rectangle.fill" : "rectangle")
                Text("Afficher le covoiturage")
                    .foregroundColor(.primary)
            }
        }
    }
    
    var list: some View {
        VStack {
            ForEach(0..<transportations.count, id: \.self) { index in
                let transportation = transportations[index]
                VStack {
                    HStack {
                        if let mainEmoji = transportation.emoji?.main {
                            Text(mainEmoji)
                            if let secondaryEmoji = transportation.emoji?.secondary {
                                Text(secondaryEmoji)
                            }
                        }
                        Text(transportation.name)
                        if transportation.actualEmissions != nil {
                            Text("\(transportation.actualEmissions!.rounded(to: 2)) kg CO2e")
                        } else {
                            Text("\(transportation.emissions.kgco2e.rounded(to: 2)) kg CO2e")
                        }
                    }
                    
                    if transportation.isDuplicated != nil,
                       let actualCarpool = transportation.actualCarpool {
                        HStack {
                            Button {
                                calculateCarpool(for: index, action: .minus)
                                sortTransportations(self.transportations)
                            } label: {
                                Image(systemName: "minus")
                            }
                            
                            Text("\(actualCarpool)")
                            
                            Button {
                                calculateCarpool(for: index, action: .plus)
                                sortTransportations(self.transportations)
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
        }
    }
    
    func updateTransportations() {
        NetworkService.shared.get(for: distance, showAllTransports: showAllTransports, showCarpool: showCarpool) { transportations in
            if let transportations {
                sortTransportations(transportations)
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

enum Action {
    case minus, plus
}

struct TransportImpactView_Previews: PreviewProvider {
    static var previews: some View {
        TransportImpactView()
    }
}
