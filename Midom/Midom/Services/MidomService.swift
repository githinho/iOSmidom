//
//  MidomService.swift
//  Midom
//
//  Created by Eugen Druzin on 17/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation

class MidomService {
    
    typealias SignalUpdate = () -> ()
    
    private let signal: SignalUpdate
    private let api: MidomApi
    private let navigation: NavigationService
    
    var error: String?

    init(midomApi: MidomApi, navigationService: NavigationService, signal: @escaping SignalUpdate) {
        self.api = midomApi
        self.navigation = navigationService
        self.signal = signal
    }
    
    func loginUser(username: String, password: String) {
        api.login(username: username, password: password) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):
                // TODO: save username and password

                self.navigation.showHome()
            case .failure(let message):
                self.error = message
                self.signal()
            }
        }
    }
    
    func getMyAccountDetails() {
        api.getMyAccountDetails() { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):
//                self.navigation.showHome()
                break
            case .failure(let message):
                self.error = message
                self.signal()
            }
        }
    }
}
