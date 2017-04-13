//
//  StartupManager.swift
//  Halo5Stats
//
//  Copyright © 2017 Justin Powell. All rights reserved.
//

import Foundation

protocol StartupManagerDelegate: class {
    func didFinishStartup()
}

class StartupManager {

    weak var delegate: StartupManagerDelegate?

    func startup() {
        buildContainers()
        runStartup()
    }

    private func buildContainers() {
        Container.register(OperationQueue.self) { _ in OperationQueue() }
    }

    private func runStartup() {
        guard let queue = Container.resolve(OperationQueue.self) else { return }

        let startupOperation = StartupOperation {
            DispatchQueue.main.async {
                self.delegate?.didFinishStartup()
            }
        }

        queue.addOperation(startupOperation)
    }
}
