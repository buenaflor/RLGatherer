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
    
    func addNewUser(_ uid: String, player: Player, completion: @escaping (Error?) -> Void) {
        db.collection("users").document(uid).setData(player.dictionary) { err in
            if let err = err {
                completion(err)
            }
            else {
                completion(nil)
            }
        }
    }
}

extension FirebaseManager {
    static let shared = FirebaseManager()
}
