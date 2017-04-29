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
    var consultationRequests: [ConsultationRequest]?
    var accounts = [AccountDetails]()

    init(midomApi: MidomApi, navigationService: NavigationService, signal: @escaping SignalUpdate) {
        self.api = midomApi
        self.navigation = navigationService
        self.signal = signal
    }
    
    func loginUser(username: String, password: String) {
        error = nil
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
    
    func getConsultationRequestsForStatus(status: RequestType) {
        error = nil
        consultationRequests = [ConsultationRequest]()
        api.getConsulationRequestByStatus(status: status) { [weak self] result in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let requests):
                var accountIds = [Int]()
                for request in requests {
                    accountIds.append(request.studyOwner!)
                    if let studyId = request.study {
                        self.error = nil
                        self.api.getStudy(studyId: studyId) { resultStudy in
                            switch resultStudy {
                            case .success(let study):
                                request.studyObj = study
                                self.consultationRequests?.append(request)
                            case .failure(let message):
                                self.error = message
                            }
                            self.signal()
                        }
                    }
                }
                self.getAccountDetails(ids: accountIds)
            case .failure(let message):
                self.error = message
                self.signal()
            }
        }
    }
    
    func getMyAccountDetails() {
        error = nil
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
    
    private func getAccountDetails(ids: [Int]) {
        var uniqueIds = Array(Set(ids))
        for account in accounts {
            if let index = uniqueIds.index(where: { $0 == account.id}) {
                uniqueIds.remove(at: index)
            }
        }
        
        for id in uniqueIds {
            error = nil
            api.getAccountDetails(id: id) { [weak self] result in
                guard let `self` = self else { return }
                
                switch result {
                case .success(let accountDetails):
                    self.accounts.append(accountDetails)
                case .failure(let error):
                    self.error = error
                    self.signal()
                }
            }
        }
    }
}
