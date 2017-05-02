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
                self.checkResponseString(checkedResult: serviceResult, completionHandler: completionHandler)
        }
    }
    
    func getConsulationRequestByStatus(status: RequestType,
                                       completionHandler: @escaping (MidomResult<[ConsultationRequest]>) -> Void) {
        manager.request(endpoint + "getCr/\(status.rawValue)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let serviceResult = self.checkResult(response: response)
                self.checkJSONArray(checkedResult: serviceResult, completionHandler: completionHandler)
        }
    }
    
    func getStudy(studyId: Int, completionHandler: @escaping (MidomResult<Study>) -> Void) {
        manager.request(endpoint + "getStudy/\(studyId)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let serviceResult = self.checkResult(response: response)
                self.checkJSONObject(checkedResult: serviceResult, completionHandler: completionHandler)
        }
    }
    
    func getMyAccountDetails(completionHandler: @escaping (MidomResult<AccountDetails>) -> Void) {
        manager.request(endpoint + "accountDetails", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let checkedResult = self.checkResult(response: response)
                self.checkJSONObject(checkedResult: checkedResult, completionHandler: completionHandler)
        }
    }
    
    func getAccountDetails(id: Int, completionHandler: @escaping (MidomResult<AccountDetails>) -> Void) {
        manager.request(endpoint + "getAccount/\(id)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let checkedResult = self.checkResult(response: response)
                self.checkJSONObject(checkedResult: checkedResult, completionHandler: completionHandler)
        }
    }
    
    func getConsultationRequestMessages(id: Int, completionHandler:
        @escaping (MidomResult<[ConsultationRequestMessage]>) -> Void) {
        manager.request(endpoint + "geCrMessages/\(id)", method: .get, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let checkedResult = self.checkResult(response: response)
                self.checkJSONArray(checkedResult: checkedResult, completionHandler: completionHandler)
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
                
                let checkedResult = self.checkResult(response: response)
                self.checkResponseString(checkedResult: checkedResult, completionHandler: completionHandler)
        }
    }
    
    func sendConsultationComment(id: Int, comment:String, completionHandler: @escaping (MidomResult<String>) -> Void) {
        let params: [String: String] = ["crId": String(id), "comment": comment]
        manager.request(endpoint + "setCrAnswer", method: .post, parameters: params, encoding: JSONEncoding.default)
            .validate()
            .responseJSON() { response in
                let checkedResult = self.checkResult(response: response)
                self.checkResponseString(checkedResult: checkedResult, completionHandler: completionHandler)
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
    
    private func checkResponseString(checkedResult: MidomResult<Any>,
                                 completionHandler: @escaping (MidomResult<String>) -> Void) {
        var result: MidomResult<String>
        switch checkedResult {
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
    
    private func checkJSONObject<T: Decodable>(checkedResult: MidomResult<Any>,
                                 completionHandler: @escaping (MidomResult<T>) -> Void) {
        var result: MidomResult<T>
        switch checkedResult {
        case .success(let message):
            if let json = message as? JSON, let object = T(json: json) {
                result = MidomResult.success(object)
            } else {
                result = MidomResult.failure("cannot deserialize JSON")
            }
        case .failure(let message):
            result = MidomResult.failure(message)
        }
        completionHandler(result)
    }
    
    private func checkJSONArray<T: Decodable>(checkedResult: MidomResult<Any>,
                                completionHandler: @escaping (MidomResult<[T]>) -> Void) {
        var result: MidomResult<[T]>
        switch checkedResult {
        case .success(let message):
            if let jsons = message as? [JSON],
                let consultationRequests = [T].from(jsonArray: jsons) {
                result = MidomResult.success(consultationRequests)
            } else {
                result = MidomResult.failure("cannot deserialize Study JSON")
            }
        case .failure(let message):
            result = MidomResult.failure(message)
        }
        completionHandler(result)
    }
    
    private func getResponseMessage(message: Any) -> String {
        if let messageString = message as? String {
            return messageString
        } else {
            return "cannot get message from JSON"
        }
    }
}
