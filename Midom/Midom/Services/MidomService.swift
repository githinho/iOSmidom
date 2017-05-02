//
//  MidomService.swift
//  Midom
//
//  Created by Eugen Druzin on 17/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import KeychainSwift

class MidomService {
    
    typealias SignalUpdate = () -> ()
    
    private let usernameKey = "KeyForUsername"
    private let passwordKey = "KeyForPassword"
    
    private let signal: SignalUpdate
    private let api: MidomApi
    private let navigation: NavigationService
    
    var error: String?
    var consultationRequests: [ConsultationRequest]?
    var accounts = [AccountDetails]()
    var crMessages = [ConsultationRequestMessage]()

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
                let keychain = KeychainSwift()
                keychain.set(username, forKey: self.usernameKey)
                keychain.set(password, forKey: self.passwordKey)
                self.navigation.showHome()
            case .failure(let message):
                self.error = message
                self.signal()
            }
        }
    }
    
    func tryToLoginUser() {
        let keychain = KeychainSwift()
        if let username = keychain.get(usernameKey),
            let password = keychain.get(passwordKey) {
            api.login(username: username, password: password) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(_):
                    self.navigation.showHome()
                case .failure(_):
                    self.navigation.showLogin()
                }
            }
        } else {
            self.navigation.showLogin()
        }
    }
    
    func logoutUser() {
        let keychain = KeychainSwift()
        keychain.clear()
        self.navigation.showLogin()
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
    
    func moveToPendingCr(vc: UIViewController, id: Int) {
        currentRequest = id
        navigation.showPendingRequest(viewController: vc, id: id)
        getConsultationRequestMessage(id: id)
    }
    
    private func getConsultationRequestMessage(id: Int) {
        // This doesn't work!!!
        if crMessages.contains(where: { $0.id == id }) {
            return
        }
        
        error = nil
        self.crMessages.removeAll()
        api.getConsultationRequestMessages(id: id) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let messages):
                self.crMessages.append(contentsOf: messages)
            case .failure(let error):
                self.error = error
            }
            self.signal()
        }
    }
    
    private func getAccountDetails(ids: [Int]) {
        var uniqueIds = Array(Set(ids))
        for account in accounts {
            if let index = uniqueIds.index(where: { $0 == account.id }) {
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
            
            api.getAvatar(accountId: id) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    if let index = self.accounts.index(where: {$0.id == id}) {
                        self.accounts[index].avatar = data
                    }
                case .failure(let error):
                    self.error = error
                }
                self.signal()
            }
        }
    }
    
    
    // NOT IN USE
    var currentRequest: Int?
    func getCurrentCrData() -> ConsultationRequestViewModel? {
        if let consultationRequest = consultationRequests?
            .first(where: { $0.id == currentRequest }),
            let account = accounts
                .first(where: { $0.id == consultationRequest.studyOwner}) {
            
            let studyName = consultationRequest.studyObj?.name ?? ""
            let date = Utils.getDateFromDouble(date: consultationRequest.creationTime)
            var comment = ""
            for message in crMessages {
                let text = message.comment ?? ""
                comment += "\(text) \n"
            }
            
            return ConsultationRequestViewModel(studyName: studyName,
                                                date: date,
                                                owner: account.getFullName(),
                                                messages: comment)
        } else {
            return nil
        }
    }
}

struct ConsultationRequestViewModel {
    let studyName: String
    let date: String
    let owner: String
    let messages: String
}
