//
//  RLResponse.swift
//  SteamGatherer
//
//  Created by Giancarlo on 07.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Endpoints
import Unbox

protocol UnboxableParser: Unboxable, ResponseParser {}

extension UnboxableParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> Self {
        return try unbox(data: data)
    }
}

//struct GetPlatformsResponse: UnboxableParser {
//    let id: String
//    let name: String
//
//    init(unboxer: Unboxer) throws {
//        id = try unboxer.unbox(key: "id")
//        name = try unboxer.unbox(key: "name")
//    }
//}

struct GetPlatformsResponse: Codable {
    let platforms: [Platform]
}

struct Platform: Codable {
    let id: Int
    let name: String
}

extension GetPlatformsResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> GetPlatformsResponse {

        let response = try JSONDecoder().decode([Platform].self, from: data)
        
        return GetPlatformsResponse(platforms: response)
    }
}

