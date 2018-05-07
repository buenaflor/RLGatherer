//
//  RLClient.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints

class RLClient: Client {
    
    let client: AnyClient = {
        let baseURL = BaseConfig.shared.baseURL
        return AnyClient(baseURL: baseURL)
    }()
    
    func encode<C>(call: C) -> URLRequest where C : Call {
        var request = client.encode(call: call)
        
        request.apply(header: nil)
        
        return request
    }
    
    func parse<C>(sessionTaskResult result: URLSessionTaskResult, for call: C) throws -> C.ResponseType.OutputType where C : Call {
        return try client.parse(sessionTaskResult: result, for: call)
    }
}

