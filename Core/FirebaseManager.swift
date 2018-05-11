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
    static let shared = FirebaseManager()
    
    private let db = Firestore.firestore()
    
    func addNewUser(_ uid: String) {
        
    }
}
