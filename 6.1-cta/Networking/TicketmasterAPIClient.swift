//
//  TicketmasterAPIClient.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
struct TicketMasterAPIClient {
    
    static let manager = TicketMasterAPIClient()
    
    
    func getEventElements(city: String, completionHandler: @escaping (Result<[EventElement], AppError>) -> () ) {
        
        var ticketmasterURL: URL {
            guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/events.json?countyCode=us&city=\(city)&size=25&apikey=\(Secret.ticketmasterKey)".replacingOccurrences(of: " ", with: "%20")) else {fatalError("Error: Invalid URL")}
               return url
           }
        
        NetworkManager.manager.performDataTask(withUrl: ticketmasterURL, httpMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                return
            case .success(let data):
                do {
                    let events = try Event.getEvents(from: data)
                    guard let eventsUnwrapped = events else {completionHandler(.failure(.invalidJSONResponse));return
                    }
                    completionHandler(.success(eventsUnwrapped))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
        
    }
    
    
    private init() {}
    
}
