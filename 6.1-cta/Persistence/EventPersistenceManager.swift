//
//  EventPersistenceManager.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/3/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation

struct EventPersistenceManager {
    
    private init() {}
    
    static let manager = EventPersistenceManager()
    
    private let persistenceHelper = PersistenceHelper<FavoriteEvent>(fileName: "favedEvents.plist")
    
    func saveFavorites(eventData: FavoriteEvent) throws {
        try persistenceHelper.save(newElement: eventData)
    }
    
    func getFavorites() throws -> [FavoriteEvent] {
        return try persistenceHelper.getObjects()
    }
    
    func delete(element: [FavoriteEvent], atIndex: Int) throws {
        try persistenceHelper.delete(elements: element, index: atIndex)
    }
}
