//
//  MuseumAPIClient.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
struct MuseumAPIClient {
    
    static let manager = MuseumAPIClient()
    
    func getArtObjects(keyWord: String, completionHandler: @escaping (Result<[ArtObject], AppError>) -> () ) {
        
        var artURL: URL {
            guard let url = URL(string: "https://www.rijksmuseum.nl/api/nl/collection?key=\(Secret.museumKey)&culture=en&q=\(keyWord)&ps=5") else {fatalError("Error: Invalid URL")}
            return url
        }
        
        NetworkManager.manager.performDataTask(withUrl: artURL, httpMethod: .get) { (result) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                return
            case .success(let data):
                do {
                    let arts = try Art.getArt(from: data)
                    guard let artsUnwrapped = arts else {completionHandler(.failure(.invalidJSONResponse));return
                    }
                    completionHandler(.success(artsUnwrapped))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
        
    }
    
    
    private init() {}
    
}
