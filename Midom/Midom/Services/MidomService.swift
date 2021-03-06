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
    
    private let signal: SignalUpdate
    private let api: MidomApi
    private let navigation: NavigationService
    private let keychain = KeychainHandler()
    
    var error: String?
    var consultationRequests: [ConsultationRequest]?
    var accounts = [AccountDetails]()
    var crMessages = [ConsultationRequestMessage]()

    init(midomApi: MidomApi,
         navigationService: NavigationService,
         signal: @escaping SignalUpdate) {
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
                self.keychain.saveUser(username: username, password: password)
                self.navigation.showHome()
            case .failure(let message):
                self.error = message
                self.signal()
            }
        }
    }
    
    func tryToLoginUser() {
        if let user = keychain.getUser() {
            api.login(username: user.username, password: user.password) { [weak self] result in
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
        keychain.clearKeychain()
        self.navigation.showLogin()
    }
    
    func getConsultationRequestsForStatus(status: RequestType) {
        error = nil
        consultationRequests = [ConsultationRequest]()
        api.getConsulationRequestByStatus(status: status) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let requests):
                self.downloadRequets(requests: requests)
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
        navigation.showPendingRequest(viewController: vc, id: id)
        getConsultationRequestMessage(id: id)
    }
    
    func moveToAcceptedCr(vc: UIViewController, id: Int) {
        // TODO: download the study
        self.getConsultationRequestMessage(id: id)
        self.navigation.showAcceptedRequest(viewController: vc, id: id)
    }
    
    func moveToComposeComment(vc: UIViewController, id: Int) {
        self.navigation.showCompose(viewController: vc, id: id)
    }
    
    func acceptPendingCr(vc: UIViewController, crId: Int) {
        error = nil
        api.answerPendingCr(accept: true, crId: crId) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):
                // TODO: download the study
                
                self.navigation.showAcceptedRequest(viewController: vc, id: crId)
                self.signal()
            case .failure(let error):
                self.error = error
                self.signal()
            }
        }
    }
    
    func rejectPendingCr(crId: Int) {
        error = nil
        api.answerPendingCr(accept: false, crId: crId) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):
                self.navigation.showHome()
            case .failure(let error):
                self.error = error
                self.signal()
            }
        }
    }
    
    func sendConsultationComment(id: Int, comment: String) {
        error = nil
        api.sendConsultationComment(id: id, comment: comment) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(_):
                self.navigation.showHome()
            case .failure(let error):
                self.error = error
                self.signal()
            }
        }
    }
    
    private func getConsultationRequestMessage(id: Int) {
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
            downloadAccountDetails(id: id)
            downloadAvatar(id: id)
        }
    }
    
    private func downloadRequets(requests: [ConsultationRequest]) {
        var accountIds = [Int]()
        for request in requests {
            accountIds.append(request.studyOwner!)
            if let studyId = request.study {
                downloadStudy(request: request, studyId: studyId)
            }
        }
        self.getAccountDetails(ids: accountIds)
    }
    
    private func downloadStudy(request: ConsultationRequest, studyId: Int) {
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
    
    private func downloadAccountDetails(id: Int) {
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
    
    private func downloadAvatar(id: Int) {
        api.getAvatar(accountId: id) { [weak self] result in
            guard let `self` = self else { return }
            switch result {
            case .success(let data):
                self.assignAvatarToAccount(id: id, data: data)
            case .failure(let error):
                self.error = error
            }
            self.signal()
        }
    }
    
    private func assignAvatarToAccount(id: Int, data: Data) {
        if let index = self.accounts.index(where: {$0.id == id}) {
            self.accounts[index].avatar = data
        }
    }
}
