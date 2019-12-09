//
//  FirestoreService.swift
//  6.1-cta
//
//  Created by Levi Davis on 12/2/19.
//  Copyright © 2019 Levi Davis. All rights reserved.
//

import Foundation
import FirebaseFirestore

fileprivate enum FireStoreCollections: String {
    case users
    case events
    case arts
}

enum SortingCriteria: String {
    case fromNewestToOldest = "dateCreated"
    var shouldSortDescending: Bool {
        switch self {
        case .fromNewestToOldest:
            return true
        }
    }
}

class FirestoreService {
    
    static let manager = FirestoreService()
    
    private let db = Firestore.firestore()
    
    //        MARK: - AppUsers
    
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields: [String : Any] = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }
    
    func updateCurrentUser(userExperience: String? = nil, completion: @escaping (Result <(), Error>) -> ()) {
        guard let userID = FirebaseAuthService.manager.currentUser?.uid else {
            return
        }
        
        var updateFields = [String : Any]()
        if let experience = userExperience {
            updateFields["userExperience"] = experience
        }
        
        
        
        //        PUT request
        db.collection(FireStoreCollections.users.rawValue).document(userID).updateData(updateFields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getAllUsers(completion: @escaping (Result<[AppUser], Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> AppUser? in
                    let userID = snapshot.documentID
                    let user = AppUser(from: snapshot.data(), id: userID)
                    return user
                })
                completion(.success(users ?? []))
            }
        }
    }
    //    MARK: - Events
    func saveEvent(event: FavoriteEvent, completion: @escaping (Result <(), Error>) -> ()){
        var fields = event.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.events.rawValue).addDocument(data: fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func getAllEvents(sortingCriteria: SortingCriteria? = nil, completion: @escaping (Result <[FavoriteEvent], Error>) -> ()) {
        let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let events = snapshot?.documents.compactMap({ (snapshot) -> FavoriteEvent? in
                    let eventID = snapshot.documentID
                    let event = FavoriteEvent(from: snapshot.data(), id: eventID)
                    return event
                })
                completion(.success(events ?? []))
            }
        }

        let collection = db.collection(FireStoreCollections.events.rawValue)
        if let sortingCriteria = sortingCriteria {
            let query = collection.order(by: sortingCriteria.rawValue, descending: sortingCriteria.shouldSortDescending)
            query.getDocuments(completion: completionHandler)
        } else {
            collection.getDocuments(completion: completionHandler)
        }
    }

    func getEvents(forUserID: String, completion: @escaping (Result <[FavoriteEvent], Error>) -> ()) {


        db.collection(FireStoreCollections.events.rawValue).whereField("creatorID", isEqualTo: forUserID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let events = snapshot?.documents.compactMap({ (snapshot) -> FavoriteEvent? in
                    let eventID = snapshot.documentID
                    let event = FavoriteEvent(from: snapshot.data(), id: eventID)
                    return event
                })
                completion(.success(events ?? []))
            }
        }
    }
    
    func deleteFavoriteEvent(forUserID: String, eventID: String, completion: @escaping (Result <(), Error>) -> ()) {
        
        db.collection(FireStoreCollections.events.rawValue).whereField("creatorID", isEqualTo: forUserID).whereField("id", isEqualTo: eventID).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents \(error)")
                completion(.failure(error))
            } else {
                for document in snapshot!.documents {
                    document.reference.delete()
                    completion(.success(()))
                }
            }
        }
        
    }
    
//    MARK: - Art collection
    
    func saveArt(art: FavoriteArt, completion: @escaping (Result <(), Error>) -> ()){
        var fields = art.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.arts.rawValue).addDocument(data: fields) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    func getAllArts(sortingCriteria: SortingCriteria? = nil, completion: @escaping (Result <[FavoriteArt], Error>) -> ()) {
        let completionHandler: FIRQuerySnapshotBlock = {(snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let arts = snapshot?.documents.compactMap({ (snapshot) -> FavoriteArt? in
                    let artID = snapshot.documentID
                    let art = FavoriteArt(from: snapshot.data(), id: artID)
                    return art
                })
                completion(.success(arts ?? []))
            }
        }

        let collection = db.collection(FireStoreCollections.arts.rawValue)
        if let sortingCriteria = sortingCriteria {
            let query = collection.order(by: sortingCriteria.rawValue, descending: sortingCriteria.shouldSortDescending)
            query.getDocuments(completion: completionHandler)
        } else {
            collection.getDocuments(completion: completionHandler)
        }
    }

    func getArts(forUserID: String, completion: @escaping (Result <[FavoriteArt], Error>) -> ()) {


        db.collection(FireStoreCollections.arts.rawValue).whereField("creatorID", isEqualTo: forUserID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let arts = snapshot?.documents.compactMap({ (snapshot) -> FavoriteArt? in
                    let artID = snapshot.documentID
                    let art = FavoriteArt(from: snapshot.data(), id: artID)
                    return art
                })
                completion(.success(arts ?? []))
            }
        }
    }
    
     func deleteFavoriteArt(forUserID: String, artID: String, completion: @escaping (Result <(), Error>) -> ()) {
           
           db.collection(FireStoreCollections.arts.rawValue).whereField("creatorID", isEqualTo: forUserID).whereField("id", isEqualTo: artID).getDocuments { (snapshot, error) in
               if let error = error {
                   print("Error getting arts \(error)")
                   completion(.failure(error))
               } else {
                   for document in snapshot!.documents {
                       document.reference.delete()
                       completion(.success(()))
                   }
               }
           }
    }
    
    private init() {}
}
