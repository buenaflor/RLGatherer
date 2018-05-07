//
//  SessionManager.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

private extension UserDefaults {
    struct Keys {
        static let LoggedIn = "LoggedIn"
    }
    
    var isLoggedIn: Bool {
        get {
            return bool(forKey: Keys.LoggedIn)
        } set {
            set(newValue, forKey: Keys.LoggedIn)
        }
    }
}
