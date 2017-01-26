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

    func validate(_ gamertag: String, shouldSaveGamertag: Bool = false, completion: @escaping (_ success: Bool) -> ()) {
        guard gamertagManager.isGamertagValid(gamertag) else {
            DispatchQueue.main.async { [weak self] in
                self?.invalidGamertagAlert()
                completion(false)
            }
            return
        }

        let request = ServiceRecordRequest(gamertags: [gamertag], gameMode: .Arena)
        let operation = APIRequestOperation(request: request, shouldParse: false) { [weak self] in
            if let data = request.data {
                guard let results = data[JSONKeys.ServiceRecord.players] as? [AnyObject], let player = results[0] as? [String : AnyObject], let resultCode = player[JSONKeys.ServiceRecord.resultCode] as? Int, let result = ResultCode(rawValue: resultCode) else {
                    DispatchQueue.main.async {
                        self?.invalidGamertagAlert()
                        completion(false)
                    }
                    return
                }

                switch result {
                case .success:
                    let saveGamertagOperation = SaveGamertagOperation(gamertag: gamertag.lowercased())
                    let downloadSpartanDataOperation = DownloadSpartanDataOperation(gamertag: gamertag.lowercased()) {
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }

                    var operations: [Operation] = []

                    if shouldSaveGamertag {
                        operations.append(saveGamertagOperation)
                    }

                    operations.append(downloadSpartanDataOperation)

                    self?.operationQueue.addOperations(operations, waitUntilFinished: false)
                case .notFound:
                    DispatchQueue.main.async {
                        self?.serviceErrorAlert(result.alertTitle, message: "That spartan does not exist. Please try another gamertag.")
                        completion(false)
                    }
                case .serviceFailure:
                    DispatchQueue.main.async {
                        self?.serviceErrorAlert(result.alertTitle, message: "The services have failed. Please try again later.")
                        completion(false)
                    }
                case .serviceNotAvailable:
                    DispatchQueue.main.async {
                        self?.serviceErrorAlert(result.alertTitle, message: "The services aren't available at this time. Please try again later.")
                        completion(false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.serviceErrorAlert("Something Went Wrong", message: "Please try again. Check to make sure your gamertag is entered correctly.")
                    completion(false)
                }
            }
        }

        operationQueue.addOperation(operation)
    }

    fileprivate func invalidGamertagAlert() {
        let alert = gamertagManager.alert(viewController)
        operationQueue.addOperation(alert)
    }

    fileprivate func serviceErrorAlert(_ title: String?, message: String?) {
        let alert = AlertOperation()
        alert.title = title
        alert.message = message

        operationQueue.addOperation(alert)
    }
}
