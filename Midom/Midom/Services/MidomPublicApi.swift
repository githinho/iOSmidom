//
//  MidomPublicApi.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import Alamofire
import Timberjack

enum MidomResult<T> {
    case success(T)
    case failure(String)
}

typealias JSONDictionary = [String: Any]

class MidomPublicApi {
    
    var manager: Alamofire.SessionManager
    let baseUrl = "http://midom.rasip.fer.hr:8080/"
    let endpoint: String
    
    init() {
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
            .responseJSON{ response in
                var serviceResult: MidomResult<String>
                switch response.result {
                case .success(let jsonDictionary):
                    let jsonDict = jsonDictionary as! JSONDictionary
                    print("login response: \(jsonDict.description)")
                    break
                case .failure(let failure):
                    print("login failure: \(failure.localizedDescription)")
                    break
                }
        }
    }
}
