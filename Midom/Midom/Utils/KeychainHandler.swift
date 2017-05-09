//
//  KeychainHandler.swift
//  Midom
//
//  Created by Eugen Druzin on 09/05/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import KeychainSwift

class KeychainHandler {
    
    private let keychain = KeychainSwift()
    private let usernameKey = "KeyForUsername"
    private let passwordKey = "KeyForPassword"
    
    func saveUser(username: String, password: String) {
        keychain.set(username, forKey: self.usernameKey)
        keychain.set(password, forKey: self.passwordKey)
    }
    
    func getUser() -> (username: String, password: String)? {
        guard let username = keychain.get(usernameKey),
            let password = keychain.get(passwordKey) else {
                return nil
        }
        return (username: username, password: password)
    }
    
    func clearKeychain() {
        keychain.clear()
    }
}
