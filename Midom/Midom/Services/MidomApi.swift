//
//  MidomPublicApi.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import Alamofire
import Gloss
import Timberjack

enum MidomResult<T> {
    case success(T)
    case failure(String)
}

class MidomApi {
    
    var manager: Alamofire.SessionManager
    let baseUrl = "http://midom.rasip.fer.hr:8080/"
    let endpoint: String
    let navigationService: NavigationService
    
    init(navigationService: NavigationService) {
        self.navigationService = navigationService
        endpoint = baseUrl + "ms/"
        Timberjack.logStyle = .verbose
        let configuration = Timberjack.defaultSessionConfiguration()
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func login(username: String, password: String,
               completionHandler: @escaping (MidomResult<String>) -> Void) {
        let parameters = [
            "username": username,
            "password": password]
        
        manager.request(endpoint + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON{ response in
                let serviceResult = self.checkResult(response: response)
                var result: MidomResult<String>
                switch serviceResult {
                case .success(let message):
                    if let successMessage = message as? String {
                        result = MidomResult.success(successMessage)
                    } else {
                        result = MidomResult.failure("cannot deserialize Study JSON")
                    }
                case .failure(let message):
                    result = MidomResult.failure(message)
                }
                completionHandler(result)
        }
    }
    
    func getConsulationRequestByStatus(status: RequestType,
                                       completionHandler: @escaping (MidomResult<[ConsultationRequest]>) -> Void) {
        manager.request(endpoint + "getCr/\(status.rawValue)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let serviceResult = self.checkResult(response: response)
                var result: MidomResult<[ConsultationRequest]>
                switch serviceResult {
                case .success(let message):
                    if let jsons = message as? [JSON],
                        let consultationRequests = [ConsultationRequest].from(jsonArray: jsons) {
                        result = MidomResult.success(consultationRequests)
                    } else {
                        result = MidomResult.failure("cannot deserialize Study JSON")
                    }
                case .failure(let message):
                    result = MidomResult.failure(message)
                }
                completionHandler(result)
        }
    }
    
    func getStudy(studyId: Int, completionHandler: @escaping (MidomResult<Study>) -> Void) {
        manager.request(endpoint + "getStudy/\(studyId)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let serviceResult = self.checkResult(response: response)
                var result: MidomResult<Study>
                switch serviceResult {
                case .success(let message):
                    if let json = message as? JSON, let study = Study(json: json) {
                        result = MidomResult.success(study)
                    } else {
                        result = MidomResult.failure("cannot deserialize Study JSON")
                    }
                case .failure(let message):
                    result = MidomResult.failure(message)
                }
                completionHandler(result)
        }
    }
    
    func getMyAccountDetails(completionHandler: @escaping (MidomResult<AccountDetails>) -> Void) {
        manager.request(endpoint + "accountDetails", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let checkedResult = self.checkResult(response: response)
                var result: MidomResult<AccountDetails>
                switch checkedResult {
                case .success(let message):
                    if let json = message as? JSON, let accoutDetails = AccountDetails(json: json) {
                        result = MidomResult.success(accoutDetails)
                    } else {
                        result = MidomResult.failure("cannot deserialize JSON for Account details")
                    }
                case .failure(let message):
                    result = MidomResult.failure(message)
                }
                completionHandler(result)
        }
    }
    
    func getAvatar(accountId: Int, completionHandler: @escaping (DataResponse<Data>) -> Void) {
        manager.request(baseUrl + "avatar/\(accountId)", method: .get)
            .validate()
            .responseData() { response in
                completionHandler(response);
        }
    }
    
    
    private func checkResult(response: DataResponse<Any>) -> MidomResult<Any> {
        var serviceResult = MidomResult<Any>.failure("TEST")
        switch response.result {
        case .success(let jsonDictionary):
            if let jsonResponse = MidomResponse(json: jsonDictionary as! [String : Any]) {
                // TODO: response code for
                switch jsonResponse.code {
                case 0:
                    serviceResult = MidomResult.success(jsonResponse.message)
                case 1:
                    if let message = jsonResponse.message as? String,
                        message == "Not logged in" {
                        navigationService.showLogin()
                    }
                    serviceResult = MidomResult.failure(getResponseMessage(message: jsonResponse.message))
                default:
                    serviceResult = MidomResult.failure(getResponseMessage(message: jsonResponse.message))
                }
            } else {
                serviceResult = MidomResult.failure("unknow response")
            }
        case .failure(let failure):
            serviceResult = MidomResult.failure(failure.localizedDescription)
        }
        return serviceResult
    }
    
    private func getResponseMessage(message: Any) -> String {
        if let messageString = message as? String {
            return messageString
        } else {
            return "cannot get message from JSON"
        }
    }
}
