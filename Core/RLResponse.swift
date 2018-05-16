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


// MARK: - Get Platforms

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


// MARK: - Get Tiers

struct GetTiersResponse: Codable {
    let tiers: [Tier]
}

struct Tier: Codable {
    let tierId: Int
    let tierName: String
}

extension GetTiersResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> GetTiersResponse {
        
        let response = try JSONDecoder().decode([Tier].self, from: data)
        
        return GetTiersResponse(tiers: response)
    }
}

extension Tier {
    var shortedTierName: String {
        if tierName.contains("Platinum") {
            return tierName.replacingOccurrences(of: "Platinum", with: "Plat.")
        }
        if tierName.contains("Grand Champion") {
            return "GC"
        }
        if tierName.contains("Champion") {
            return tierName.replacingOccurrences(of: "Champion", with: "Champ.")
        }
        if tierName.contains("Diamond") {
            return tierName.replacingOccurrences(of: "Diamond", with: "Dia.")
        }
        if tierName.contains("Unranked") {
            return "UNR"
        }
        else {
            return tierName
        }
    }
}

extension Player {
    var shortedTierName: String {
        if rank.contains("Platinum") {
            return rank.replacingOccurrences(of: "Platinum", with: "Plat.")
        }
        if rank.contains("Grand Champion") {
            return "GC"
        }
        if rank.contains("Champion") {
            return rank.replacingOccurrences(of: "Champion", with: "Champ.")
        }
        if rank.contains("Diamond") {
            return rank.replacingOccurrences(of: "Diamond", with: "Dia.")
        }
        if rank.contains("Unranked") {
            return "UNR"
        }
        else {
            return rank
        }
    }
    
    var shortedMode: String {
        if mode.contains("Duel") {
            return "1v1"
        }
        if mode.contains("Doubles") {
            return "2v2"
        }
        if mode.contains("Standard") {
            return "3v3"
        }
        if mode.contains("Chaos") {
            return "4v4"
        }
        if mode.contains("Mashup") {
            return "Mutator"
        }
        else { return mode }
    }
}


// MARK: - Get Playlists

struct GetPlaylistsResponse: Codable {
    let playlists: [Playlist]
}

struct Playlist: Codable {
    let id, platformId: Int
    let name: String
    let population: Population
}

struct Population: Codable {
    let players, updatedAt: Int
}

extension GetPlaylistsResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> GetPlaylistsResponse {
        
        let response = try JSONDecoder().decode([Playlist].self, from: data)
        
        return GetPlaylistsResponse(playlists: response)
    }
}

extension Playlist {
    var platformName: String {
        switch platformId {
        case 1:
            return "Steam"
        case 2:
            return "PS4"
        case 3:
            return "XboxOne"
        default:
            return "Error"
        }
    }
    
    var modeName: String {
        switch name {
        case "Duel":
            return "1v1 Duel"
        case "Doubles":
            return "2v2 Doubles"
        case "Standard":
            return "3v3 Standard"
        case "Chaos":
            return "4v4 Chaos"
        case "Ranked Duel":
            return "1v1 Ranked Duel"
        case "Ranked Doubles":
            return "2v2 Ranked Doubles"
        case "Ranked Standard":
            return "3v3 Ranked Standard"
        case "Mutator Mashup":
            return "Mutator Mashup"
        case "Snow Day":
            return "Snow Day"
        case "Rocket Labs":
            return "Rocket Labs"
        case "Hoops":
            return "Hoops"
        case "Rumble":
            return "Rumble"
        case "Dropshot":
            return "Dropshot"
        default:
            return "Mode not found"
        }
    }
}


// MARK: - Get Player

struct GetPlayerResponse: Codable {
    let player: PlayerData
}

struct PlayerData: Codable {
    let uniqueId, displayName: String
    let platform: Platform
    let avatar: String?
    let profileUrl, signatureUrl: String
    let stats: Stats
    let rankedSeasons: [String: [String: RankedSeason]]
    let lastRequested, createdAt, updatedAt, nextUpdateAt: Int
}

struct RankedSeason: Codable {
    let rankPoints: Int
    let matchesPlayed, tier, division: Int?
}

struct Stats: Codable {
    let wins, goals, mvps, saves: Int
    let shots, assists: Int
}

extension GetPlayerResponse: ResponseParser {
    static func parse(data: Data, encoding: String.Encoding) throws -> GetPlayerResponse {
        
        let response = try JSONDecoder().decode(PlayerData.self, from: data)
        
        return GetPlayerResponse(player: response)
    }
}
