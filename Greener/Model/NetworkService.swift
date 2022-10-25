//
//  NetworkService.swift
//  Greener
//
//  Created by Raphaël Payet on 25/10/2022.
//

import Foundation
import Alamofire

class NetworkService {
    static let shared = NetworkService()
    
    let urlString = "https://api.monimpacttransport.fr/beta/getEmissionsPerDistance?"
    
    func get(for distance: Double) {
        var finalURL = "\(urlString)km=\(distance)"
        finalURL += "&filter=smart" // Could also be "&filter=all"
        finalURL += "&fields=source,emoji,description,carpool,display"
        AF.request(finalURL).response { response in
            guard let data = response.data else { return }
            do {
                let apiResponse = try? JSONDecoder().decode([Transportation].self, from: data)
                // TODO: To be handle in the UI, as a callback/completionHandler
                print(apiResponse)
            }
        }
    }
}


