//
//  GamertagValidator.swift
//  Halo5Stats
//
//  Copyright © 2016 Justin Powell. All rights reserved.
//

import UIKit

class GamertagValidator {

    let gamertagManager = GamertagManager.sharedManager
    let operationQueue = UIApplication.appController().operationQueue

    var viewController: UIViewController!

    func validate(gamertag: String, shouldSaveGamertag: Bool = false, completion: (success: Bool) -> ()) {
        guard gamertagManager.isGamertagValid(gamertag) else {
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.invalidGamertagAlert()
                completion(success: false)
            }
            return
        }

        let request = ServiceRecordRequest(gamertags: [gamertag], gameMode: .Arena)
        let operation = APIRequestOperation(request: request, shouldParse: false) { [weak self] in
            if let data = request.data {
                guard let results = data[JSONKeys.ServiceRecord.players] as? [AnyObject], player = results[0] as? [String : AnyObject], resultCode = player[JSONKeys.ServiceRecord.resultCode] as? Int, result = ResultCode(rawValue: resultCode) else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.invalidGamertagAlert()
                        completion(success: false)
                    }
                    return
                }

                switch result {
                case .success:
                    let saveGamertagOperation = SaveGamertagOperation(gamertag: gamertag.lowercaseString)
                    let downloadSpartanDataOperation = DownloadSpartanDataOperation(gamertag: gamertag.lowercaseString) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(success: true)
                        }
                    }

                    var operations: [Operation] = []

                    if shouldSaveGamertag {
                        operations.append(saveGamertagOperation)
                    }

                    operations.append(downloadSpartanDataOperation)

                    self?.operationQueue.addOperations(operations, waitUntilFinished: false)
                case .notFound:
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.serviceErrorAlert(result.alertTitle, message: "That spartan does not exist. Please try another gamertag.")
                        completion(success: false)
                    }
                case .serviceFailure:
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.serviceErrorAlert(result.alertTitle, message: "The services have failed. Please try again later.")
                        completion(success: false)
                    }
                case .serviceNotAvailable:
                    dispatch_async(dispatch_get_main_queue()) {
                        self?.serviceErrorAlert(result.alertTitle, message: "The services aren't available at this time. Please try again later.")
                        completion(success: false)
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self?.serviceErrorAlert("Something Went Wrong", message: "Please try again. Check to make sure your gamertag is entered correctly.")
                    completion(success: false)
                }
            }
        }

        operationQueue.addOperation(operation)
    }

    private func invalidGamertagAlert() {
        let alert = gamertagManager.alert(viewController)
        operationQueue.addOperation(alert)
    }

    private func serviceErrorAlert(title: String?, message: String?) {
        let alert = AlertOperation()
        alert.title = title
        alert.message = message

        operationQueue.addOperation(alert)
    }
}
