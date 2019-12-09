//
//  Art.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation

struct Art: Codable {
    let artObjects: [ArtObject]
    
    static func getArt(from jsonData: Data) throws -> [ArtObject]? {
        let response = try JSONDecoder().decode(Art.self, from: jsonData)
        return response.artObjects
    }
}

//MARK: - ArtObject

struct ArtObject: Codable {
    let title: String
    let principalOrFirstMaker: String
    let longTitle: String
    let webImage: WebImage?
    let id: String
    
    func existsInFavorites(completion: @escaping (Result<Bool,Error>) -> ()) {
        
        guard let user = FirebaseAuthService.manager.currentUser else {return}
        
        FirestoreService.manager.getArts(forUserID: user.uid) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                print(error)
            case .success(let events):
                if events.contains(where: {$0.id == self.id}) {
                    completion(.success(true))
                } else {
                    completion(.success(false))
                }
            }
        }
    }
}

//MARK: - WebImage

struct WebImage: Codable {
    let url: String
}


/**
 {
     "elapsedMilliseconds": 0,
     "count": 9006,
     "countFacets": {
         "hasimage": 7203,
         "ondisplay": 227
     },
     "artObjects": [
         {
             "links": {
                 "self": "http://www.rijksmuseum.nl/api/nl/collection/SK-A-4691",
                 "web": "http://www.rijksmuseum.nl/nl/collectie/SK-A-4691"
             },
             "id": "nl-SK-A-4691",
             "objectNumber": "SK-A-4691",
             "title": "Zelfportret",
             "hasImage": true,
             "principalOrFirstMaker": "Rembrandt van Rijn",
             "longTitle": "Zelfportret, Rembrandt van Rijn, ca. 1628",
             "showImage": true,
             "permitDownload": true,
             "webImage": {
                 "guid": "89de22aa-e19f-4c83-87ff-26dd8f319c05",
                 "offsetPercentageX": 0,
                 "offsetPercentageY": 0,
                 "width": 2118,
                 "height": 2598,
                 "url": "https://lh3.googleusercontent.com/7qzT0pbclLB7y3fdS1GxzMnV7m3gD3gWnhlquhFaJSn6gNOvMmTUAX3wVlTzhMXIs8kM9IH8AsjHNVTs8em3XQI6uMY=s0"
             },
             "headerImage": {
                 "guid": "99061015-b788-42ed-a9d8-06db0bcf39e3",
                 "offsetPercentageX": 0,
                 "offsetPercentageY": 0,
                 "width": 1920,
                 "height": 460,
                 "url": "https://lh3.googleusercontent.com/WKIxue0nAIOYj00nGVoO4DTP9rU2na0qat5eoIuQTf6Fbp4mHHm-wbCes1Oo6K_6IdMl6Z_OCjGW_juCCf_jvQqaKw=s0"
             },
             "productionPlaces": []
         },
*/
