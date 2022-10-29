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
    
    func get(for distance: Double, showAllTransports: Bool = false, showCarpool: Bool = false, closure: @escaping (([Transportation]?) -> Void)) {
        var url = createURL(for: distance, showAllTransports: showAllTransports, showCarpool: showCarpool)
        AF.request(url).response { response in
            guard let data = response.data else { return }
            do {
                guard var apiResponse = try? JSONDecoder().decode([Transportation].self, from: data) else { return }
                apiResponse = self.createDuplicatesIfNeeded(response: apiResponse)
                closure(apiResponse)
            }
        }
    }

    
    // MARK: Helpers
    func createURL(for distance: Double, showAllTransports: Bool = false, showCarpool: Bool = false) -> String {
        var url = "\(urlString)km=\(distance)"
        url += showAllTransports ? "&filter=all" : "&filter=smart" // Could also be "&filter=all"
        url += "&fields=emoji" // "&fields=source,emoji,description,carpool,display"
        url += showCarpool ? ",carpool" : ""
        return url
    }
    
    func createDuplicatesIfNeeded(response: [Transportation]) -> [Transportation] {
        var newResponse = response
        for object in response {
            if object.carpool != nil {
                // Duplicate object
                var newObject = object
                newObject.id = response.count // This is in conflict with the way we set the type
                newObject.isDuplicated = true
                // Calculate the new emission with the default number of carpool ( 2 people using the transportation )
                newObject.emissions.kgco2e = self.divideEmissions(by: 2, sourceEmission: object.emissions.kgco2e)
                // Append the object to the response
                newResponse.append(newObject)
            }
        }
        return newResponse
    }
    
    func divideEmissions(by carpool: Int, sourceEmission: Double) -> Double {
        sourceEmission / Double(carpool)
    }
}


