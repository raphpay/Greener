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
            ForEach(transportations) { transportation in
                HStack {
                    if let mainEmoji = transportation.emoji?.main {
                        Text(mainEmoji)
                        if let secondaryEmoji = transportation.emoji?.secondary {
                            Text(secondaryEmoji)
                        }
                    }
                    Text(transportation.name)
                    Text("\(transportation.emissions.kgco2e.rounded(to: 2)) kg CO2e")
                }
            }
        }
    }
    
    func updateTransportations() {
        NetworkService.shared.get(for: distance, showAllTransports: showAllTransports, showCarpool: showCarpool) { transportations in
            if let transportations {
                DispatchQueue.main.async {
                    self.transportations = transportations.sorted(by: { $0.emissions.kgco2e < $1.emissions.kgco2e })
                }
            }
        }
    }
}

struct TransportImpactView_Previews: PreviewProvider {
    static var previews: some View {
        TransportImpactView()
    }
}
