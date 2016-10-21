//
//  APIConstants.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

typealias GameMode = APIConstants.GameMode
typealias ResultCode = APIConstants.ResultCode

struct APIConstants {
    
    static let KeyHeader = "Ocp-Apim-Subscription-Key"
    
    static let Scheme = "https"
    static let Domain = "www.haloapi.com/"

    static let Halo5Title = "h5"
    
    // MARK: - Services
    static let StatsService = "stats"
    static let ProfileService = "profile"
    static let MetadataService = "metadata"
    
    // MARK: - Paths
    static let StatsPlayerMatches = "players/[GAMERTAG]/matches" // [?modes][&start][&count]
    static let StatsServiceRecords = "servicerecords/[GAME_MODE]" // players(required) (arena [&seasonId])
    static let StatsCarnageReport = "[GAME_MODE]/matches/[MATCH_ID]"
    
    static let Profile = "profiles/[GAMERTAG]/[TYPE]" // [&size] (spartan [&crop])
    
    static let Metadata = "metadata/[TYPE_OF_METADATA]"
    
    // MARK: - Path Keys
    static let GamertagKey = "GAMERTAG"
    static let GameModeKey = "GAME_MODE"
    static let MatchIdKey = "MATCH_ID"
    static let ProfileTypeKey = "TYPE" // emblem, spartan
    static let MetadataKey = "TYPE_OF_METADATA"
    
    // MARK: - Game Modes
    
    enum GameMode: String {
        case Arena = "arena"
        case Custom = "custom"
        case Warzone = "warzone"

        static func gameMode(forInt i: Int) -> GameMode? {
            switch i {
            case 1:
                return .Arena
            case 3:
                return .Custom
            case 4:
                return .Warzone
            default:
                return nil
            }
        }

        var color: UIColor {
            switch self {
            case .Arena:
                return UIColor(haloColor: .ArenaAccent)
            case .Custom:
                return UIColor(haloColor: .CustomAccent)
            case .Warzone:
                return UIColor(haloColor: .WarzoneAccent)
            }
        }

        var title: String {
            switch self {
            case .Arena:
                return "Arena"
            case .Warzone:
                return "Warzone"
            case .Custom:
                return "Custom"
            }
        }

        static func multiplayerModes() -> String {
            let arena = GameMode.Arena.rawValue
            let custom = GameMode.Custom.rawValue
            let warzone = GameMode.Warzone.rawValue
            return "\(arena),\(custom),\(warzone)"
        }

        var image: UIImage {
            switch self {
            case .Arena:
                return UIImage(named: "fathom")!
            case .Warzone:
                return UIImage(named: "skirmish")!
            case .Custom:
                return UIImage(named: "narrows")!
            }
        }
    }

    enum ResultCode: Int {
        case success = 0
        case notFound = 1
        case serviceFailure = 2
        case serviceNotAvailable = 3

        var alertTitle: String? {
            switch self {
            case .notFound:
                return "Not Found"
            case .serviceFailure:
                return "Service Failure"
            case .serviceNotAvailable:
                return "Service Not Available"
            default:
                return nil
            }
        }
    }
    
    static let emblem = "emblem"
    static let spartan = "spartan"
    
    // MARK: - Parameter keys
    static let PlayersKey = "players" // String of gamertags separated by commas
    static let ArenaSeasonId = "seasonId"
    static let MatchesModes = "modes"
    static let MatchesStart = "start" // Int, match number
    static let MatchesCount = "count"
    static let ProfileSize = "size"
    static let ProfileSpartanCrop = "crop"
    
    // MARK: - Base Path constructor
    static func basePath(service: String) -> String {
        return "\(service)/\(Halo5Title)/"
    }
    
    // MARK: Metadata Types
    
    enum MetadataType: String {
        case CSRDesignations = "csr-designations"
        case Enemies = "enemies"
        case GameBaseVariants = "game-base-variants"
        case Maps = "maps"
        case Medals = "medals"
        case Playlists = "playlists"
        case Seasons = "seasons"
        case TeamColors = "team-colors"
        case Vehicles = "vehicles"
        case Weapons = "weapons"
    }
}
