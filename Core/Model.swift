//
//  Model.swift
//  SteamGatherer
//
//  Created by Giancarlo on 09.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct Player {
    let id: String
    let name: String
    let rank: String
    let platformID: String
    let platform: String
    let mode: String
    let gatherAction: String
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "platformID": platformID,
            "platform": platform,
            "rank": rank,
            "mode": mode,
            "gatherAction": gatherAction
        ]
    }
}

extension Player: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let id = dictionary["id"] as? String,
            let name = dictionary["name"] as? String,
            let platformID = dictionary["platformID"] as? String,
            let platform = dictionary["platform"] as? String,
            let rank = dictionary["rank"] as? String,
            let mode = dictionary["mode"] as? String,
            let gatherAction = dictionary["gatherAction"] as? String
            else { return nil }
        
        self.init(id: id, name: name, rank: rank, platformID: platformID, platform: platform, mode: mode, gatherAction: gatherAction)
    }
}


