//
//  FirebaseManager.swift
//  SteamGatherer
//
//  Created by Giancarlo on 09.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseManager {
    
    private let db = Firestore.firestore()
    
    private lazy var settings: FirestoreSettings = {
        let settings = FirestoreSettings()
        settings.areTimestampsInSnapshotsEnabled = true
        return settings
    }()
    
    init() {
        db.settings = settings
    }
    
    func addNewUser(player: Player, completion: @escaping (Error?) -> Void) {
        db.collection(Firebase.Key.collection).document(player.id).setData(player.dictionary) { err in
            if let err = err {
                completion(err)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func fetchCurrentUser(uid: String, completion: @escaping (Player?, Error?) -> Void) {
        db.collection(Firebase.Key.collection).document(uid).getDocument { (documentSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil, err)
            } else {
                guard let document = documentSnapshot, let data = document.data() else { return }
                let player = Player(dictionary: data)
                completion(player, nil)
            }
        }
    }
    
    func updateCurrentUser(player: Player, completion: @escaping (Error?) -> Void) {
        db.collection(Firebase.Key.collection).document(player.id).updateData([
            "mode": player.mode,
            "rank": player.rank,
            "gatherAction": player.gatherAction,
            "platformID": player.platformID,
            "name": player.name
        ]) { err in
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
}

extension FirebaseManager {
    static let shared = FirebaseManager()
}
