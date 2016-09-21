//
//  DownloadAndParseMetadataOperation.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import Foundation

class DownloadAndParseMetadataOperation: GroupOperation {

    let csrOperation: APIRequestOperation
    let weaponOperation: APIRequestOperation
    let vehicleOperation: APIRequestOperation
    let playlistOperation: APIRequestOperation
    let seasonOperation: APIRequestOperation
    let enemyOperation: APIRequestOperation
    let medalOperation: APIRequestOperation
    let teamColorOperation: APIRequestOperation
    let gameBaseVariantOperation: APIRequestOperation

    init(completion: Void -> Void) {
        let csrRequest = MetadataRequest(metadataType: .CSRDesignations)
        csrOperation = APIRequestOperation(request: csrRequest) {
            print("CSR Designations downloaded and parsed")
        }

        let weaponRequest = MetadataRequest(metadataType: .Weapons)
        weaponOperation = APIRequestOperation(request: weaponRequest) {
            print("Weapons downloaded and parsed")
        }

        let vehicleRequest = MetadataRequest(metadataType: .Vehicles)
        vehicleOperation = APIRequestOperation(request: vehicleRequest) {
            print("Vehicles downloaded and parsed")
        }

        let playlistRequest = MetadataRequest(metadataType: .Playlists)
        playlistOperation = APIRequestOperation(request: playlistRequest) {
            print("Playlists downloaded and parsed")
        }

        let seasonRequest = MetadataRequest(metadataType: .Seasons)
        seasonOperation = APIRequestOperation(request: seasonRequest) {
            print("Seasons downloaded and parsed")
        }

        let enemyRequest = MetadataRequest(metadataType: .Enemies)
        enemyOperation = APIRequestOperation(request: enemyRequest) {
            print("Enemies downloaded and parsed")
        }

        let medalRequest = MetadataRequest(metadataType: .Medals)
        medalOperation = APIRequestOperation(request: medalRequest) {
            print("Medals downloaded and parsed")
        }

        let teamColorsRequest = MetadataRequest(metadataType: .TeamColors)
        teamColorOperation = APIRequestOperation(request: teamColorsRequest) {
            print("Team Colors downloaded and parsed")
        }

        let gbvRequest = MetadataRequest(metadataType: .GameBaseVariants)
        gameBaseVariantOperation = APIRequestOperation(request: gbvRequest) {
            print("Game Base Variants downloaded and parsed")
        }

        let finishOperation = NSBlockOperation(block: completion)

        weaponOperation.addDependency(csrOperation)
        vehicleOperation.addDependency(weaponOperation)
        playlistOperation.addDependency(vehicleOperation)
        seasonOperation.addDependency(playlistOperation)
        enemyOperation.addDependency(seasonOperation)
        medalOperation.addDependency(enemyOperation)
        teamColorOperation.addDependency(medalOperation)
        gameBaseVariantOperation.addDependency(teamColorOperation)
        finishOperation.addDependency(gameBaseVariantOperation)

        let operations = [csrOperation, weaponOperation, vehicleOperation, playlistOperation, seasonOperation, enemyOperation, medalOperation, teamColorOperation, gameBaseVariantOperation, finishOperation]

        super.init(operations: operations)

        name = "Download and Parse Metadata"
    }
}