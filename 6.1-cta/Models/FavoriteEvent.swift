//
//  FavoriteEvent.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/3/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FavoriteEvent: Codable {
    let name: String
    let photoURL: String
    let id: String
    let creatorID: String
    let dateCreated: Date?
    
    //    MARK: - Init
    
    init(name: String, photoURL: String, id: String, creatorID: String, dateCreated: Date? = nil) {
        self.name = name
        self.photoURL = photoURL
        self.id = id
        self.creatorID = creatorID
        self.dateCreated = dateCreated
    }
    
    init?(from dict: [String : Any], id: String) {
        guard let name = dict["name"] as? String,
            let photoURL = dict["photoURL"] as? String,
            let id = dict["id"] as? String,
            let creatorID = dict["creatorID"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else {return nil}
        
        self.name = name
        self.photoURL = photoURL
        self.creatorID = creatorID
        self.dateCreated = dateCreated
        self.id = id
    }
    
    var fieldsDict: [String : Any] {
        return ["name": self.name, "photoURL" : self.photoURL, "id": self.id, "creatorID" : self.creatorID]
    }
    
}
