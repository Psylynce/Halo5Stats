//
//  JSONKeyConstants.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

struct JSONKeys {

    static let identifier = "id"
    static let name = "name"
    static let overview = "description"
    static let imageUrl = "imageUrl"
    static let iconUrl = "iconUrl"

    // MARK: - Metadata

    struct CSR {
        static let csrDesignation = APIConstants.MetadataType.CSRDesignations.rawValue
        static let bannerImageUrl = "bannerImageUrl"
        static let tiers = "tiers"
        static let iconImageUrl = "iconImageUrl"
        static let tierIdentifier = "id"
    }

    struct Enemy {
        static let enemies = APIConstants.MetadataType.Enemies.rawValue
        static let faction = "faction"
        static let largeIconUrl = "largeIconImageUrl"
        static let smallIconUrl = "smallIconImageUrl"
    }

    struct GameBaseVariant {
        static let gameBaseVariants = APIConstants.MetadataType.GameBaseVariants.rawValue
        static let supportedGameModes = "supportedGameModes"
    }

    struct Map {
        static let maps = APIConstants.MetadataType.Maps.rawValue
        static let supportArray = "supportedGameModes"
    }

    struct Medal {
        static let medals = APIConstants.MetadataType.Medals.rawValue
        static let classification = "classification"
        static let difficulty = "difficulty"
        static let spriteLocation = "spriteLocation"
        static let spriteSheetUrl = "spriteSheetUri"
        static let left = "left"
        static let top = "top"
        static let width = "width"
        static let height = "height"
        static let spriteWidth = "spriteWidth"
        static let spriteHeight = "spriteHeight"
    }

    struct Playlist {
        static let playlists = APIConstants.MetadataType.Playlists.rawValue
        static let isRanked = "isRanked"
        static let gameMode = "gameMode"
        static let isActive = "isActive"
    }

    struct Season {
        static let seasons = APIConstants.MetadataType.Seasons.rawValue
        static let endDate = "endDate"
        static let startDate = "startDate"
        static let isActive = "isActive"
    }

    struct TeamColor {
        static let teamColors = APIConstants.MetadataType.TeamColors.rawValue
        static let color = "color"
    }

    struct Vehicle {
        static let vehicles = APIConstants.MetadataType.Vehicles.rawValue
        static let largeIconUrl = "largeIconImageUrl"
        static let smallIconUrl = "smallIconImageUrl"
        static let isUsable = "isUsableByPlayer"
    }

    struct Weapon {
        static let weapons = APIConstants.MetadataType.Weapons.rawValue
        static let type = "type"
        static let largeIconUrl = "largeIconImageUrl"
        static let smallIconUrl = "smallIconImageUrl"
        static let isUsable = "isUsableByPlayer"
    }

    // MARK: - Stats

    static let Identifier = "Id"
    static let Gamertag = "Gamertag"
    static let GameMode = "GameMode"
    static let OwnerType = "OwnerType"
    static let GameVariant = "GameVariant"
    static let MapVariant = "MapVariant"
    static let ResourceId = "ResourceId"
    static let SeasonId = "SeasonId"
    static let ISODate = "ISO8601Date"
    static let WeaponWithMostKills = "WeaponWithMostKills"

    struct Matches {
        static let matches = "Results"
        static let matchId = "MatchId"
        static let playlistId = "HopperId"
        static let completionDate = "MatchCompletedDate"
        static let gameBaseVariantId = "GameBaseVariantId"
        static let isTeamGame = "IsTeamGame"
        static let mapId = "MapId"
        static let matchDuration = "MatchDuration"
        static let links = "Links"
        static let matchDetails = "StatsMatchDetails"
        static let matchPath = "Path"
        static let players = "Players"
        static let player = "Player"
        static let result = "Result"
        static let teams = "Teams"
        static let rank = "Rank"
        static let score = "Score"
    }

    struct BaseStats {
        static let totalKills = "TotalKills"
        static let totalDeaths = "TotalDeaths"
        static let totalAssists = "TotalAssists"
        static let totalHeadshots = "TotalHeadshots"
        static let totalShotsFired = "TotalShotsFired"
        static let totalShotsLanded = "TotalShotsLanded"
        static let totalWeaponDamage = "TotalWeaponDamage"
        static let totalMeleeKills = "TotalMeleeKills"
        static let totalMeleeDamage = "TotalMeleeDamage"
        static let totalAssassinations = "TotalAssassinations"
        static let totalGroundPoundKills = "TotalGroundPoundKills"
        static let totalGroundPoundDamage = "TotalGroundPoundDamage"
        static let totalShoulderBashKills = "TotalShoulderBashKills"
        static let totalShoulderBashDamage = "TotalShoulderBashDamage"
        static let totalGrenadeKills = "TotalGrenadeKills"
        static let totalGrenadeDamage = "TotalGrenadeDamage"
        static let totalPowerWeaponKills = "TotalPowerWeaponKills"
        static let totalPowerWeaponDamage = "TotalPowerWeaponDamage"
        static let totalPowerWeaponGrabs = "TotalPowerWeaponGrabs"
        static let totalPowerWeaponPossessionTime = "TotalPowerWeaponPossessionTime"
    }

    struct WeaponStats {
        static let weaponWithMostKills = "WeaponWithMostKills"
        static let weaponStats = "WeaponStats"
        static let weaponId = "WeaponId"
        static let identifier = "StockId"
        static let attachments = "Attachments"
        static let totalShotsFired = "TotalShotsFired"
        static let totalShotsLanded = "TotalShotsLanded"
        static let totalKills = "TotalKills"
        static let totalHeadshots = "TotalHeadshots"
        static let totalDamage = "TotalDamageDealt"
        static let totalPossessionTime = "TotalPossessionTime"
    }

    struct CarnageReport {
        static let playerStats = "PlayerStats"
        static let player = "Player"
        static let didNotFinish = "DNF"
        static let teamId = "TeamId"
        static let averageLifeTime = "AvgLifeTimeOfPlayer"
        static let totalDuration = "TotalDuration"
        static let rank = "Rank"
    }

    struct ServiceRecord {
        static let players = "Results"
        static let serviceRecord = "Result"
        static let arenaStats = "ArenaStats"
        static let totalGamesCompleted = "TotalGamesCompleted"
        static let totalGamesWon = "TotalGamesWon"
        static let totalGamesLost = "TotalGamesLost"
        static let totalGamesTied = "TotalGamesTied"
        static let totalTimePlayed = "TotalTimePlayed"
        static let gamertag = "Id"
        static let highestCSRPlaylistId = "HighestCsrPlaylistId"
        static let highestCSRSeasonId = "HighestCsrSeasonId"
        static let arenaPlaylistSeasonId = "ArenaPlaylistStatsSeasonId"
        static let resultCode = "ResultCode"
        static let highestCSRAttained = "HighestCsrAttained"
        static let spartanRank = "SpartanRank"
    }

    struct AttainedCSR {
        static let highestCsrAttained = "HighestCsrAttained"
        static let tier = "Tier"
        static let designationId = "DesignationId"
        static let csr = "Csr"
        static let percentToNextTier = "PercentToNextTier"
        static let rank = "Rank"
    }

    struct MedalAward {
        static let medals = "MedalAwards"
        static let medalId = "MedalId"
        static let count = "Count"
    }

    struct EnemyKill {
        static let vehicles = "DestroyedEnemyVehicles"
        static let aiEnemies = "EnemyKills"
        static let enemy = "Enemy"
        static let id = "BaseId"
        static let attachments = "Attachments"
        static let totalKills = "TotalKills"
    }

    struct OpponentDetail {
        static let killedBy = "KilledByOpponentDetails"
        static let killed = "KilledOpponentDetails"
        static let gamertag = "GamerTag"
        static let totalKills = "TotalKills"
    }
}
