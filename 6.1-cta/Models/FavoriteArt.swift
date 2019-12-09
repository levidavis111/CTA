//
//  FavoriteArt.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/3/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FavoriteArt {
    
    let title: String
    let longTitle: String
    let principalOrFirstMaker: String
    let photoURL: String
    let id: String
    let creatorID: String
    let dateCreated: Date?
    
    //    MARK: - Init
    
    init(title: String, longTitle: String, principalOrFirstMaker: String, photoURL: String, id: String, creatorID: String, dateCreated: Date? = nil) {
        self.title = title
        self.longTitle = longTitle
        self.principalOrFirstMaker = principalOrFirstMaker
        self.photoURL = photoURL
        self.id = id
        self.creatorID = creatorID
        self.dateCreated = dateCreated
    }
    
    init?(from dict: [String : Any], id: String) {
        guard let title = dict["title"] as? String,
            let longTitle = dict["longTitle"] as? String,
            let principalOrFirstMaker = dict["principalOrFirstMaker"] as? String,
            let photoURL = dict["photoURL"] as? String,
            let id = dict["id"] as? String,
            let creatorID = dict["creatorID"] as? String,
            let dateCreated = (dict["dateCreated"] as? Timestamp)?.dateValue() else {return nil}
        
        self.title = title
        self.longTitle = longTitle
        self.principalOrFirstMaker = principalOrFirstMaker
        self.photoURL = photoURL
        self.creatorID = creatorID
        self.dateCreated = dateCreated
        self.id = id
    }
    
    var fieldsDict: [String : Any] {
        return ["title": self.title, "longTitle" : self.longTitle, "principalOrFirstMaker" : self.principalOrFirstMaker, "photoURL" : self.photoURL, "id": self.id, "creatorID" : self.creatorID]
    }
}

