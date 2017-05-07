//
//  ApiValidation.swift
//  Midom
//
//  Created by Eugen Druzin on 07/05/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Alamofire
import Foundation
import Gloss

class ApiValidation {
    
    private let navigationService: NavigationService
    
    init(navigationService: NavigationService) {
        self.navigationService = navigationService
    }
    
    func checkString(response: DataResponse<Any>,
                     completionHandler: @escaping (MidomResult<String>) -> Void) {
        let serviceResult = self.checkResult(response: response)
        self.checkResponseString(checkedResult: serviceResult, completionHandler: completionHandler)
    }
    
    func checkJSONObject<T: Decodable>(response: DataResponse<Any>,
                         completionHandler: @escaping (MidomResult<T>) -> Void) {
        let serviceResult = self.checkResult(response: response)
        self.checkJSONObject(checkedResult: serviceResult, completionHandler: completionHandler)
    }
    
    func checkJSONArray<T: Decodable>(response: DataResponse<Any>,
                           completionHandler: @escaping (MidomResult<[T]>) -> Void) {
        let serviceResult = self.checkResult(response: response)
        self.checkJSONArray(checkedResult: serviceResult, completionHandler: completionHandler)
    }
    
    func checkResult(response: DataResponse<Any>) -> MidomResult<Any> {
        var serviceResult = MidomResult<Any>.failure("Initial failure")
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
    
    private func validateString(checkedResult: MidomResult<Any>,
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
    
    private func validateJSONObject<T: Decodable>(checkedResult: MidomResult<Any>,
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
    
    private func validateJSONArray<T: Decodable>(checkedResult: MidomResult<Any>,
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
