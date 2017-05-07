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
    let validator: ApiValidation
    
    init(navigationService: NavigationService) {
        self.navigationService = navigationService
        endpoint = baseUrl + "ms/"
        Timberjack.logStyle = .verbose
        let configuration = Timberjack.defaultSessionConfiguration()
        manager = Alamofire.SessionManager(configuration: configuration)
        validator = ApiValidation(navigationService: navigationService)
    }
    
    func login(username: String, password: String,
               completionHandler: @escaping (MidomResult<String>) -> Void) {
        let parameters = [
            "username": username,
            "password": password]
        
        manager.request(endpoint + "login", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseJSON{ response in
                self.validator.checkString(response: response, completionHandler: completionHandler)
        }
    }
    
    func getConsulationRequestByStatus(status: RequestType,
                                       completionHandler: @escaping (MidomResult<[ConsultationRequest]>) -> Void) {
        manager.request(endpoint + "getCr/\(status.rawValue)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                self.validator.checkJSONArray(response: response, completionHandler: completionHandler)
        }
    }
    
    func getStudy(studyId: Int, completionHandler: @escaping (MidomResult<Study>) -> Void) {
        manager.request(endpoint + "getStudy/\(studyId)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                self.validator.checkJSONObject(response: response, completionHandler: completionHandler)
        }
    }
    
    func getMyAccountDetails(completionHandler: @escaping (MidomResult<AccountDetails>) -> Void) {
        manager.request(endpoint + "accountDetails", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                self.validator.checkJSONObject(response: response, completionHandler: completionHandler)
        }
    }
    
    func getAccountDetails(id: Int, completionHandler: @escaping (MidomResult<AccountDetails>) -> Void) {
        manager.request(endpoint + "getAccount/\(id)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                self.validator.checkJSONObject(response: response, completionHandler: completionHandler)
        }
    }
    
    func getConsultationRequestMessages(id: Int, completionHandler:
        @escaping (MidomResult<[ConsultationRequestMessage]>) -> Void) {
        manager.request(endpoint + "geCrMessages/\(id)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                self.validator.checkJSONArray(response: response, completionHandler: completionHandler)
        }
    }
    
    func answerPendingCr(accept: Bool, crId: Int, completionHandler: @escaping (MidomResult<String>) -> Void) {
        var answer: String
        if accept {
            answer = "acceptRequest"
        } else {
            answer = "rejectRequest"
        }
        
        let params: [String: String] = ["requestId": String(crId)]
        manager.request(endpoint + answer, method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                self.validator.checkString(response: response, completionHandler: completionHandler)
        }
    }
    
    func sendConsultationComment(id: Int, comment:String, completionHandler: @escaping (MidomResult<Any>) -> Void) {
        let params: [String: String] = ["crId": String(id), "comment": comment]
        manager.request(endpoint + "setCrAnswer", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let checkedResult = self.validator.checkResult(response: response)
                completionHandler(checkedResult)
        }
    }
    
    func getAvatar(accountId: Int, completionHandler: @escaping (MidomResult<Data>) -> Void) {
        manager.request(baseUrl + "avatar/\(accountId)", method: .get)
            .validate()
            .responseData() { response in
                var result: MidomResult<Data>
                switch response.result {
                case .success(let data):
                    result = MidomResult.success(data)
                case .failure(let error) :
                    result = MidomResult.failure(error.localizedDescription)
                }
                completionHandler(result);
        }
    }
}
