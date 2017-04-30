//
//  AccountDetails.swift
//  Midom
//
//  Created by Eugen Druzin on 08/04/2017.
//  Copyright © 2017 ne. All rights reserved.
//

import Foundation
import Gloss

class AccountDetails: Decodable {
    
    var id: Int?
    var username: String?
    var firstName: String?
    var lastName: String?
    var organisation: String?
    var description: String?
    var location: String?
    var telephon: String?
    var email: String?
    var otherContact: String?
    var isAvailable: Bool?
    var specialisations: [Specialisation]?
    var avatar: Data?
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        self.username = "username" <~~ json
        self.firstName = "firstName" <~~ json
        self.lastName = "lastName" <~~ json
        self.organisation = "organisation" <~~ json
        self.description = "description" <~~ json
        self.location = "location" <~~ json
        self.telephon = "telephon" <~~ json
        self.email = "email" <~~ json
        self.otherContact = "otherContact" <~~ json
        self.isAvailable = "isAvailable" <~~ json
        self.specialisations = "specialisations" <~~ json
    }
    
    public func getFullName() -> String {
        guard let first = firstName, let last = lastName else {
            return ""
        }
        return "\(first) \(last)"
    }
}
