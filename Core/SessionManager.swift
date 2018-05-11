//
//  SessionManager.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation
import Endpoints
import FirebaseAuth

enum ClientType {
    
    case rlClient
    
    var client: Client {
        switch self {
        case .rlClient:
            return RLClient()
        }
    }
}

class SessionManager {
    static let shared = SessionManager(clientType: .rlClient)
    
    private let defaults = UserDefaults.standard
    
    private let rlSession: Session<RLClient>
    
    private var clientType: ClientType?
    
    public var tiers = [Tier]()
    
    init(clientType: ClientType) {
        self.clientType = clientType
        rlSession = {
            let client = RLClient()
            let session = Session(with: client)
            #if DEBUG
            session.debug = true
            #endif
            
            return session
        }()
    }
    
    public var isLoggedIn: Bool {
        return defaults.isLoggedIn
    }
    
    public var newUser: Bool {
        return defaults.newUser
    }
    
    public func updateAuthentication() {
        defaults.isLoggedIn = true
    }
    
    public func setNewUser(_ value: Bool) {
        defaults.newUser = value
    }
    
    public func signOut() {
        do {
            try Auth.auth().signOut()
            defaults.isLoggedIn = false
            print("Signed out")
        } catch let err {
            print(err)
        }
    }
    
    @discardableResult
    public func start<C: Call>(call: C, completion: @escaping (Result<C.ResponseType.OutputType>) -> Void) -> URLSessionTask {
        guard let clientType = clientType else { fatalError("ClientType not defined") }
        
        switch clientType {
        case .rlClient:
            let task = rlSession.start(call: call, completion: completion)
            return task
        }
    }
}

private extension UserDefaults {
    struct Keys {
        static let LoggedIn = "LoggedIn"
        static let NewUser = "NewUser"
    }
    
    var isLoggedIn: Bool {
        get {
            return bool(forKey: Keys.LoggedIn)
        } set {
            set(newValue, forKey: Keys.LoggedIn)
        }
    }
    
    var newUser: Bool {
        get {
            return bool(forKey: Keys.NewUser)
        } set {
            set(newValue, forKey: Keys.NewUser)
        }
    }
}
