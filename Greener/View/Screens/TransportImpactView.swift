//
//  TransportImpactView.swift
//  Greener
//
//  Created by Raphaël Payet on 26/10/2022.
//

import SwiftUI

struct TransportImpactView: View {
    
    @ObservedObject var viewModel = TransportImpactViewViewModel()
    
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
            Text("Distance: \(viewModel.distance.rounded(to: 2))")
            
            HStack {
                Button {
                    if viewModel.distance - 10 > 0 {
                        viewModel.distance -= 10
                    }
                    viewModel.updateTransportations()
                } label: {
                    Image(systemName: "minus.circle")
                }

                Slider(value: $viewModel.distance, in: 0...1000) { editing in
                    if !editing {
                        viewModel.updateTransportations()
                    }
                }
                
                Button {
                    if viewModel.distance + 10 < 1000 {
                        viewModel.distance += 10
                    }
                    viewModel.updateTransportations()
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
                viewModel.showAllTransports.toggle()
                viewModel.updateTransportations()
            } label: {
                Image(systemName: viewModel.showAllTransports ? "checkmark.rectangle.fill" : "rectangle")
                Text("Afficher tous les modes de transport")
                    .foregroundColor(.primary)
            }
            
            Button {
                viewModel.showCarpool.toggle()
                viewModel.updateTransportations()
            } label: {
                Image(systemName: viewModel.showCarpool ? "checkmark.rectangle.fill" : "rectangle")
                Text("Afficher le covoiturage")
                    .foregroundColor(.primary)
            }
        }
    }
    
    var list: some View {
        VStack {
            ForEach(0..<viewModel.transportations.count, id: \.self) { index in
                let transportation = viewModel.transportations[index]
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
                                viewModel.calculateCarpool(for: index, action: .minus)
                                viewModel.sortTransportations(viewModel.transportations)
                            } label: {
                                Image(systemName: "minus")
                            }
                            
                            Text("\(actualCarpool)")
                            
                            Button {
                                viewModel.calculateCarpool(for: index, action: .plus)
                                viewModel.sortTransportations(viewModel.transportations)
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
        }
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
